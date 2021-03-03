//
//  FlickrFavoriteModel.swift
//  FlickrDemo
//
//  Created by 林紘毅 on 2021/3/2.
//

import Foundation

class FlickrFavoriteModel: NSObject, NSSecureCoding, NSCopying {

    static var supportsSecureCoding: Bool = true;
    
    var favorite:Bool = false;
    var imageUrl:String? = "";
    var title:String? = "";
    var id:String! = "";
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - Creating, Copying, and Dellocating method

    //================================================================================
    //
    //================================================================================
    required init(favorite:Bool, imageUrl:String, title:String) {
        self.favorite = favorite;
        self.imageUrl = imageUrl;
        self.title = title;
    
        super.init();
    }
    
    
    
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    //MARK: - NSCoding Method
    
    //================================================================================
    //
    //================================================================================
    required init(coder aDecoder: NSCoder) {
        favorite = aDecoder.decodeObject(forKey: "favorite") as! Bool;
        imageUrl = aDecoder.decodeObject(forKey: "imageUrl") as? String;
        title = aDecoder.decodeObject(forKey: "title") as? String;
    }
    
    
    //================================================================================
    //
    //================================================================================
    func encode(with coder: NSCoder) {
        coder.encode(favorite, forKey: "favorite");
        coder.encode(imageUrl, forKey: "imageUrl");
        coder.encode(title, forKey: "title");
    }
    
    
    
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - NSCopy method

    //================================================================================
    //
    //================================================================================
    func copy(with zone: NSZone? = nil) -> Any
    {
        return type(of:self).init(favorite: self.favorite, imageUrl: self.imageUrl ?? "", title: self.title ?? "");
    }
    
}
