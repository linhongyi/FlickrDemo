//
//  FavoriteViewController.swift
//  FlickrDemo
//
//  Created by 林紘毅 on 2021/3/2.
//

import UIKit

class FavoriteViewController: BaseCollectionViewController {

    
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Responding to View's event

    //================================================================================
    //
    //================================================================================
    override func viewDidLoad() {
        super.viewDidLoad();
        
        //////////////////////////////////////////////////

        self.tabBarController?.navigationItem.title = FVC_MLS_MyFavorite;
    }

    
    
    
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - Override Prepare ViewModel method
    
    //================================================================================
    //
    //================================================================================
    override func bindViewModel()
    {
        self.flickrListViewModel?.reloadDataCompleted = ({
            DispatchQueue.main.async {
               
             
                self.collectionView?.reloadData();
            
                if(self.flickrListViewModel?.numberSections(forFilter:false) ?? 0<=0)
                {
                    self.view.showToast(text: Common_MLS_NoDataDisplay);
                }
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
        self.loadData();
    }
    
    
    //================================================================================
    //
    //================================================================================
    internal override func loadData()
    {
        self.flickrListViewModel?.loadLocalFavoriteData(forFilter: false);
    }
    
    
    
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // MARK: - Override Button Action Method
    //================================================================================
    //
    //================================================================================
    @objc override func onClickFavorite(button:UIButton)
    {
        super.onClickFavorite(button: button);
        
        //////////////////////////////////////////////////

        guard let superView:FlickrListCollectionCellView = button.superview as? FlickrListCollectionCellView else
        {
            return;
        }
        
        guard let indexPath = self.collectionView?.indexPath(for: superView) else
        {
            return;
        }
        
        //////////////////////////////////////////////////

        if(self.flickrListViewModel?.removeRowModelAtIndexPath(indexPath: indexPath, forFilter: false)==true)
        {
            self.flickrListViewModel?.sortFavoriteDataAndReload(forFilter: false);
        }
    }
}
