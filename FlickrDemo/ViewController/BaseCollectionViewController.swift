//
//  BaseCollectionViewController.swift
//  FlickrDemo
//
//  Created by 林紘毅  on 2021/3/3.
//

import UIKit


////////////////////////////////////////////////////////////////////////////////////////////////////

// MARK: - Class

class BaseCollectionViewController: UIViewController,
                                    UICollectionViewDataSource,
                                    UICollectionViewDelegate,
                                    UICollectionViewDelegateFlowLayout{

    internal var flickrListViewModel : FlickrListViewModel?;
    
    internal var collectionView : UICollectionView?;
 
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - Creating, Copying and Dellocating Object method
    
    //================================================================================
    //
    //================================================================================
    init(viewModel: FlickrListViewModel)
    {
        super.init(nibName: nil, bundle: nil)
        self.flickrListViewModel = viewModel
    }
    
    //================================================================================
    //
    //================================================================================
    required init?(coder: NSCoder) {
        super.init(coder: coder);
    }
    
    
    
    
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - Respoding to View's Event
    
    //================================================================================
    //
    //================================================================================
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //////////////////////////////////////////////////
        
        self.view.backgroundColor = UIColor.white;
        
        //////////////////////////////////////////////////
        
        self.bindViewModel();
    }
    
    
    //================================================================================
    //
    //================================================================================
    public override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated);
        
        //////////////////////////////////////////////////
        
        self.createMainUI();
        
        //////////////////////////////////////////////////
        
        self.firstLoadData();
    }
    
    
    //================================================================================
    //
    //================================================================================
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        //////////////////////////////////////////////////
        
        self.removeMainUI();
    }
    

    

    
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // MARK: - Internal Button Action Method
    //================================================================================
    //
    //================================================================================
    @objc internal func onClickFavorite(button:UIButton)
    {
        guard let superView:FlickrListCollectionCellView = button.superview as? FlickrListCollectionCellView else
        {
            return;
        }
        
        guard let indexPath = self.collectionView?.indexPath(for: superView) else
        {
            return;
        }
        
        if(self.flickrListViewModel?.onFavoriteChanged(image: superView.imageView?.image, indexPath: indexPath, forFilter: false)==false)
        {
            
        }
        
        
        guard let rowModel:FlickrFavoriteRowModel = self.flickrListViewModel?.rowModelAtIndexPath(indexPath: indexPath, forFilter: false) as? FlickrFavoriteRowModel else
        {
            return;
        }
        
        superView.updateFavoriteButtonImage(favorite: rowModel.favorite);
    }
    
    
    
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - Internal UI method
    
    //================================================================================
    //
    //================================================================================
    internal func createMainUI()
    {
        let layout = UICollectionViewFlowLayout.init();
        layout.itemSize = CGSize(width: self.view.bounds.size.width/2, height: self.view.bounds.size.height/2);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        
        if let tabbarController = self.tabBarController
        {
            let height = self.view.bounds.size.height-tabbarController.tabBar.bounds.size.height;
            
            self.collectionView = UICollectionView.init(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: height), collectionViewLayout: layout);
          
        }
    
        
        guard let _collectionView = self.collectionView else {
            return;
        }
    
        _collectionView.backgroundColor = UIColor.clear;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.register(FlickrListCollectionCellView.self, forCellWithReuseIdentifier: "FlickrListCollectionCellView");
      
        self.view.addSubview(_collectionView);
    }
    
    
    //================================================================================
    //
    //================================================================================
    internal func removeMainUI()
    {
        self.collectionView?.delegate = nil;
        self.collectionView?.dataSource = nil;
        
        self.collectionView?.removeFromSuperview();
        self.collectionView = nil;
    }
    
    
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - Internal Prepare ViewModel method
    
    //================================================================================
    //
    //================================================================================
    internal func bindViewModel()
    {
    }
    
    
    
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - Internal Load Flickr method
    
    //================================================================================
    //
    //================================================================================
    internal func firstLoadData()
    {
        
    }
    
    
    //================================================================================
    //
    //================================================================================
    internal func loadData()
    {
    }
    
    
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - UICollectionViewDatasource method
    
    //================================================================================
    //
    //================================================================================
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return self.flickrListViewModel?.numberSections(forFilter: false) ?? 0;
    }
    
    
    //================================================================================
    //
    //================================================================================
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        let count = self.flickrListViewModel?.numberOfRowsInSection(section: section, forFilter: false) ?? 0;
        
        return count;
    }
    
    
    //================================================================================
    //
    //================================================================================
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if let cell:FlickrListCollectionCellView = collectionView.dequeueReusableCell(withReuseIdentifier: "FlickrListCollectionCellView", for: indexPath) as? FlickrListCollectionCellView {
            
            guard let rowModel:FlickrFavoriteRowModel = self.flickrListViewModel?.rowModelAtIndexPath(indexPath: indexPath, forFilter: false) as? FlickrFavoriteRowModel else
            {
                return cell;
            }
            
            cell.bottomLabel?.text = rowModel.text;
            
            cell.favoriteButton?.addTarget(self, action: #selector(onClickFavorite), for: UIControl.Event.touchUpInside);
            
            cell.updateFavoriteButtonImage(favorite: rowModel.favorite);
            
            //////////////////////////////////////////////////
           
         
            if let flickrPhotoModel = rowModel.object as? FlickrPhotoModel
            {
                cell.showImageLoading();
                
                DownloadImageService.sharedInstance.loadImageFromModel(model: flickrPhotoModel){ (image:UIImage?) in
                    cell.hideImageLoading();
                    cell.imageView?.image = image;
                };
            }
            else
            {
                cell.imageView?.image = LocalImageService.sharedInstance.getSavedImage(named: rowModel.id+Flickr_ImageExtension);
            }
            
            return cell;
        }
        else
        {
            return UICollectionViewCell();
        }
    }
    
    
    
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: -  UICollectionViewLayoutDelegate Method
    
    //================================================================================
    //
    //================================================================================
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: collectionView.bounds.size.width/2, height: collectionView.bounds.size.width/2);
    }
}
