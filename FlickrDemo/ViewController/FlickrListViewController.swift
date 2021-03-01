//
//  FlickrListViewController.swift
//  FlickrDemo
//
//  Created by 林紘毅 on 2021/3/1.
//

import UIKit

////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: - Protocol
protocol FlickrListViewControllerDelegate {
    func flickrListViewControllerDidBack(flickrListViewController:FlickrListViewController);
}





////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: - Class
class FlickrListViewController: UIViewController , UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {


    public var delegate : FlickrListViewControllerDelegate?;
    private var flickrListViewModel : FlickrListViewModel?;
    private var flickrAPIViewModel : FlickrAPIViewModel?;
 
    private var collectionView : UICollectionView?;
    
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
    override func viewDidLoad() {
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
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated);
        
        //////////////////////////////////////////////////

        self.createMainUI();
        
        //////////////////////////////////////////////////

        self.loadData();
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
    // MARK: - Private UI method

    //================================================================================
    //
    //================================================================================
    private func createMainUI()
    {
        let layout = UICollectionViewFlowLayout.init();
        layout.itemSize = CGSize(width: self.view.bounds.size.width/2, height: self.view.bounds.size.height/2);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        
        self.collectionView = UICollectionView.init(frame: self.view.bounds, collectionViewLayout: layout);
      
        
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
    private func removeMainUI()
    {
  
    }
    
    
    
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - Private Prepare ViewModel method
    
    //================================================================================
    //
    //================================================================================
    private func bindViewModel()
    {
        self.flickrAPIViewModel = FlickrAPIViewModel();
    }
    
    
    
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - Private Load Flickr method

    //================================================================================
    //
    //================================================================================
    private func loadData()
    {
        guard let _keyword = self.flickrListViewModel?.keyword else
        {
            return;
        }
        
        guard let _page = self.flickrListViewModel?.page else
        {
            return;
        }
        
        guard let _countPerPage = self.flickrListViewModel?.countPerPage else
        {
            return;
        }
        
        self.flickrAPIViewModel?.loadPage(keyword: _keyword, page: _page, perPage: _countPerPage) {  [weak self] (response:FlickrPhotoResponse?, error:Error?) in
        
            guard let _flickrListViewModel = self?.flickrListViewModel else
            {
                return;
            }
            
            //////////////////////////////////////////////////
            
            guard let _response = response else
            {
                return;
            }
            
            //////////////////////////////////////////////////

            if(_flickrListViewModel.page==0)
            {
                _flickrListViewModel.clearAndloadDataFromResponse(flickrPhotoResponse: _response) {
                    DispatchQueue.main.async {
                        self?.collectionView?.reloadData();
                    }
                };
            }
            else
            {
                _flickrListViewModel.appendDataFromResponse(flickrPhotoResponse: _response) {
                    DispatchQueue.main.async {
                        self?.collectionView?.reloadData();
                    }
                };
            }
        };
    }
    
    
    
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - Private Delegate method

    //================================================================================
    //
    //================================================================================
    @objc private func requestSendBack()
    {
        guard let _delegate = self.delegate else {
            return;
        }
      
        _delegate.flickrListViewControllerDidBack(flickrListViewController: self);
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
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if let cell:FlickrListCollectionCellView = collectionView.dequeueReusableCell(withReuseIdentifier: "FlickrListCollectionCellView", for: indexPath) as? FlickrListCollectionCellView {
            
            let rowModel = self.flickrListViewModel?.rowModelAtIndexPath(indexPath: indexPath, forFilter: false);
            
            cell.bottomLabel?.text = rowModel?.text;
            
            guard let flickrPhotoModel = rowModel?.object as? FlickrPhotoModel else
            {
                return cell;
            }
            
            
            DownloadImageViewModel.sharedInstance.loadImageFromModel(model: flickrPhotoModel){ (image:UIImage?) in
                cell.imageView?.image = image;
            };
            
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
