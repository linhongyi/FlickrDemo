//
//  RootCoordinator.swift
//  FlickrDemo
//
//  Created by 林紘毅 on 2021/3/1.
//

import UIKit

class RootCoordinator: NSObject, MainViewControllerDelegate{

    ////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - Private Present  method
    
    //================================================================================
    //
    //================================================================================
    func presentFlickrListViewController(viewController:UIViewController, keyword: String, cuntOfPage: Int)
    {
        let myTabBar = UITabBarController();
        
        myTabBar.tabBar.backgroundColor = UIColor.clear;
    

        let flickrListViewModel = FlickrListViewModel()
        
        flickrListViewModel.page = Flickr_StartPage;
        flickrListViewModel.countPerPage = cuntOfPage;
        flickrListViewModel.keyword = keyword;
        
        //////////////////////////////////////////////////

        let flickrListViewController : FlickrListViewController = FlickrListViewController.init(viewModel: flickrListViewModel);
      
        flickrListViewController.tabBarItem =
            UITabBarItem(tabBarSystemItem:.search, tag: 100)
        
        //////////////////////////////////////////////////

        let favoriteViewModel = FlickrListViewModel()
        
        favoriteViewModel.page = Flickr_StartPage;
        favoriteViewModel.countPerPage = cuntOfPage;
        favoriteViewModel.keyword = keyword;
        
        //////////////////////////////////////////////////

        let favoriteViewController : FavoriteViewController = FavoriteViewController.init(viewModel: favoriteViewModel);
     
        favoriteViewController.tabBarItem =
            UITabBarItem(tabBarSystemItem:.favorites, tag: 101)
        
        myTabBar.viewControllers = [
            flickrListViewController, favoriteViewController];
        
        
        viewController.navigationController?.pushViewController(myTabBar, animated: true);
    }
    
    
    
    
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - MainViewControllerDelegate method
    
    //================================================================================
    //
    //================================================================================
    func mainViewControllerDidSearch(mainViewController: MainViewController, keyword: String, countOfPage: Int)
    {
        self.presentFlickrListViewController(viewController: mainViewController, keyword: keyword, cuntOfPage: countOfPage);
    }
}
