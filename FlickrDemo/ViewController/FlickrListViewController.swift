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
class FlickrListViewController: UIViewController , UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {


    public var delegate : FlickrListViewControllerDelegate?;
    private var flickrListViewModel : FlickrListViewModel?;
    private var flickrAPIViewModel : FlickrAPIViewModel?;
 
    private var collectionView : UICollectionView?;
    private var refreshControl : UIRefreshControl?;
    private var bottomSpinner : UIActivityIndicatorView?
    
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
        self.bottomSpinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium);
        self.bottomSpinner?.color = UIColor.darkGray;
        self.bottomSpinner?.hidesWhenStopped = true;
       
        //////////////////////////////////////////////////

        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(refreshControlDidChanged), for: UIControl.Event.valueChanged)
   
        //////////////////////////////////////////////////

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
        _collectionView.refreshControl = self.refreshControl;
        
      
        self.view.addSubview(_collectionView);
        
        //////////////////////////////////////////////////
        
        guard let _bottomSpinner = self.bottomSpinner else {
            return;
        }
        
        self.collectionView?.addSubview(_bottomSpinner);
        
    }
    
    
    //================================================================================
    //
    //================================================================================
    private func removeMainUI()
    {
        self.refreshControl?.removeFromSuperview();
        self.refreshControl = nil;
        
        self.bottomSpinner?.removeFromSuperview();
        self.bottomSpinner = nil
        
        
        self.collectionView?.delegate = nil;
        self.collectionView?.dataSource = nil;
        
        self.collectionView?.removeFromSuperview();
        self.collectionView = nil;
    }
    
    
    
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - Private Prepare ViewModel method
    
    //================================================================================
    //
    //================================================================================
    private func bindViewModel()
    {
        self.flickrAPIViewModel = FlickrAPIViewModel();
        
        //////////////////////////////////////////////////

        self.flickrListViewModel?.reloadDataCompleted = ({
            DispatchQueue.main.async {
                
                if(self.refreshControl?.isRefreshing==true)
                {
                    self.refreshControl?.endRefreshing();
                }
                else if(self.bottomSpinner?.isAnimating==true)
                {
                    self.bottomSpinner?.stopAnimating();
                }
                
                
                self.collectionView?.reloadData();
                self.collectionView?.collectionViewLayout.invalidateLayout();
                
                //////////////////////////////////////////////////

                guard let collectionHeight = self.collectionView?.collectionViewLayout.collectionViewContentSize.height else
                {
                    return;
                }
                
                self.bottomSpinner?.frame = CGRect(x: 0,
                                                   y: Double(collectionHeight),
                                                   width: Double(self.collectionView?.frame.size.width ?? self.view.bounds.size.width),
                                                   height: FLVC_BottomSpinnerHeight);
                
                self.collectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: CGFloat(FLVC_BottomSpinnerHeight), right: 0);
            }
        });
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

            if(_flickrListViewModel.page==Flickr_StartPage)
            {
                _flickrListViewModel.clearAndloadDataFromResponse(flickrPhotoResponse: _response, forFilter: false);
            }
            else
            {
                _flickrListViewModel.appendDataFromResponse(flickrPhotoResponse: _response, forFilter: false);
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
    // MARK: - Private RefreshControl action method

    //================================================================================
    //
    //================================================================================
    @objc func refreshControlDidChanged()
    {
        self.flickrListViewModel?.page = Flickr_StartPage;
        
        self.loadData();
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
            

            cell.showImageLoading();
            
            DownloadImageViewModel.sharedInstance.loadImageFromModel(model: flickrPhotoModel){ (image:UIImage?) in
                cell.hideImageLoading();
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
    
    
    
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - UIScrollViewDelegte method

    //================================================================================
    //
    //================================================================================
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
       
        repeat
        {
            if distanceFromBottom >= height {
                break
            }
            

            if(self.flickrListViewModel?.supportPageLoad(forFilter: false)==false)
            {
                break
            }
            
            
            if(self.bottomSpinner?.isAnimating==true)
            {
                break
            }
            
            if(self.flickrListViewModel?.numberOfRowsInSection(section: 0, forFilter: false) ?? 0<=0)
            {
                break
            }
            
            
            self.flickrListViewModel?.page += 1;
            self.bottomSpinner?.startAnimating()
            self.loadData();
            
        } while(0 != 0)
    }
}
