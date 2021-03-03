//
//  FlickrFavoriteModel.swift
//  FlickrDemo
//
//  Created by 林紘毅 on 2021/3/2.
//

import Foundation

class FlickrFavoriteModel: NSObject, NSSecureCoding, NSCopying {

    static var supportsSecureCoding: Bool = true;
    
    var title:String? = "";
    var id:String! = "";
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - Creating, Copying, and Dellocating method

    //================================================================================
    //
    //================================================================================
    required init(id:String, title:String) {
  
        self.id = id;
        self.title = title;
    
        super.init();
    }
    
    
    
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    //MARK: - NSCoding Method
    
    //================================================================================
    //
    //================================================================================
    required init(coder aDecoder: NSCoder) {

        id = aDecoder.decodeObject(forKey: "id") as? String;
        title = aDecoder.decodeObject(forKey: "title") as? String;
    }
    
    
    //================================================================================
    //
    //================================================================================
    func encode(with coder: NSCoder) {
        coder.encode(id, forKey: "id");
        coder.encode(title, forKey: "title");
    }
    
    
    
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - NSCopy method

    //================================================================================
    //
    //================================================================================
    func copy(with zone: NSZone? = nil) -> Any
    {
        return type(of:self).init(id: self.id ?? "", title: self.title ?? "");
    }
    
}
