//
//  FlickerPhotosModel.swift
//  FlickrDemo
//
//  Created by 林紘毅 on 2021/3/1.
//

import Foundation

class FlickerPhotosModel : Decodable{
    var photo:Array<FlickrPhotoModel>;
    var page:Int;
    var pages:Int;
    var perpage:Int;
    var total:String;
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // MARK: - Creating, Copying, and Dellocating method

    //================================================================================
    //
    //================================================================================
    required init(from decoder: Decoder) throws {
            
        enum CodingKeys: CodingKey {
               case photo, page, pages, perpage, total, stats
        }
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        photo = try container.decode(Array.self, forKey: .photo);
        page = try container.decode(Int.self, forKey: .page);
        pages = try container.decode(Int.self, forKey: .pages);
        perpage = try container.decode(Int.self, forKey: .perpage);
        total = try container.decode(String.self, forKey: .total);
    }
}
