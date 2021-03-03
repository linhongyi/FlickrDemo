//
//  FlickrListViewController.swift
//  FlickrDemo
//
//  Created by 林紘毅 on 2021/3/1.
//

import UIKit

////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: - Class
internal class FlickrListViewController: BaseCollectionViewController{

    private var flickrAPIViewModel : FlickrAPIViewModel?;
 
    private var refreshControl : UIRefreshControl?;
    private var bottomSpinner : UIActivityIndicatorView?
    
    
    
    
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Responding to View's event

    //================================================================================
    //
    //================================================================================
    override func viewDidLoad() {
        super.viewDidLoad();
        
        //////////////////////////////////////////////////

        guard let keyword = self.flickrListViewModel?.keyword else
        {
            return;
        }
        
        self.tabBarController?.navigationItem.title = FLV_MLS_SearchResult + " " + keyword;
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
    // MARK: - Override UI method

    //================================================================================
    //
    //================================================================================
    override func createMainUI()
    {
        super.createMainUI();
        
        //////////////////////////////////////////////////

        self.bottomSpinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium);
        self.bottomSpinner?.color = UIColor.darkGray;
        self.bottomSpinner?.hidesWhenStopped = true;
       
        //////////////////////////////////////////////////

        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(refreshControlDidChanged), for: UIControl.Event.valueChanged)
   
        //////////////////////////////////////////////////

        self.collectionView?.refreshControl = self.refreshControl;
        
        //////////////////////////////////////////////////
        
        guard let _bottomSpinner = self.bottomSpinner else {
            return;
        }
        
        self.collectionView?.addSubview(_bottomSpinner);
    }
    
    
    //================================================================================
    //
    //================================================================================
    override func removeMainUI()
    {
        super.removeMainUI();
        
        //////////////////////////////////////////////////

        self.refreshControl?.removeFromSuperview();
        self.refreshControl = nil;
        
        self.bottomSpinner?.removeFromSuperview();
        self.bottomSpinner = nil
    }
    
    
    
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - Override Prepare ViewModel method
    
    //================================================================================
    //
    //================================================================================
    override func bindViewModel()
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
    // MARK: - Override Load Flickr method

    //================================================================================
    //
    //================================================================================
    internal override func firstLoadData()
    {
        if(self.flickrListViewModel?.numberSections(forFilter: false) ?? 0<=0)
        {
            self.loadData();
        }
        else
        {
            self.flickrListViewModel?.updateFavoriteData(forFilter: false);
        }
    }
    
    
    
    //================================================================================
    //
    //================================================================================
    internal override func loadData()
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
    // MARK: - UIScrollViewDelegte method

    //================================================================================
    //
    //================================================================================
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard let collectionView = scrollView as?UICollectionView else {
            return;
        }
        
        
        let height = scrollView.frame.size.height;
        let contentYoffset = scrollView.contentOffset.y;
        let distanceFromBottom = collectionView.collectionViewLayout.collectionViewContentSize.height - contentYoffset;
       
        repeat
        {
            if distanceFromBottom >= height {
                break;
            }
            

            if(self.flickrListViewModel?.supportPageLoad(forFilter: false)==false)
            {
                break;
            }
            
            
            if(self.bottomSpinner?.isAnimating==true)
            {
                break;
            }
            
            if(self.flickrListViewModel?.numberOfRowsInSection(section: 0, forFilter: false) ?? 0<=0)
            {
                break;
            }
            
            
            self.flickrListViewModel?.page += 1;
            self.bottomSpinner?.startAnimating();
            self.loadData();
            
        } while(0 != 0)
    }
}
