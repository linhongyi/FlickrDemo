//
//  FlickrDemo+ParameterDefine.swift
//  FlickrDemo
//
//  Created by 林紘毅 on 2021/2/28.
//

import UIKit

////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: API Define

let FlickrPhotoSearchAPI = "https://www.flickr.com/services/rest/?method=flickr.photos.search";
let FlickrPhotoURL = "https://live.staticflickr.com/";
let Client_Key = "cac21bb6ea79262d4c33a08a1e496694";
let Client_Secret = "b0e128d8fe8d51d2";

let Flickr_StartPage = 1;




////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: Image Cached method

let FlickrDemo_ImageCachedCount = 50;
let FlickrDemo_MaximumDownloadImageTask = 50;





////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: MainViewController ParameterDefine

let MVC_TextFieldHeight = 44;
let MVC_ButtonHeight = 44;
let MVC_ContentEdgeInsets:UIEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10);





////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: FlickrListViewController ParameterDefine

let FLVC_BottomSpinnerHeight = 44.0;
let FLVC_ImageLoadBusyIndicatorViewSize = CGSize(width: 30, height: 30);
