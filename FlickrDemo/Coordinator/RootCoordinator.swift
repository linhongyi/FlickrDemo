//
//  RootCoordinator.swift
//  FlickrDemo
//
//  Created by 林紘毅 on 2021/3/1.
//

import UIKit

class RootCoordinator: NSObject, MainViewControllerDelegate, FlickrListViewControllerDelegate{

    ////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Private Present  method
    
    //================================================================================
    //
    //================================================================================
    func presentFlickrListViewController(viewController:UIViewController, keyword: String, cuntOfPage: Int)
    {
        let flickrListViewModel = FlickrListViewModel()
        
        flickrListViewModel.page = 0;
        flickrListViewModel.countPerPage = cuntOfPage;
        flickrListViewModel.keyword = keyword;
        
        //////////////////////////////////////////////////

        let flickrListViewController : FlickrListViewController = FlickrListViewController.init(viewModel: flickrListViewModel);
        flickrListViewController.delegate = self;
      
        
        viewController.navigationController?.pushViewController(flickrListViewController, animated: true);
    }
    
    
    
    
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: MainViewControllerDelegate method
    
    //================================================================================
    //
    //================================================================================
    func mainViewControllerDidSearch(mainViewController: MainViewController, keyword: String, countOfPage: Int)
    {
        self.presentFlickrListViewController(viewController: mainViewController, keyword: keyword, cuntOfPage: countOfPage);
    }
    
    
    
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - FlickrListViewControllerDelegate method

    //================================================================================
    //
    //================================================================================
    func flickrListViewControllerDidBack(flickrListViewController: FlickrListViewController)
    {
        flickrListViewController.navigationController?.popViewController(animated: true);
    }

}
