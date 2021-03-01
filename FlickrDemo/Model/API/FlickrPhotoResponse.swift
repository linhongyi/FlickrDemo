//
//  FlickrPhotoResponse.swift
//  FlickrDemo
//
//  Created by 林紘毅 on 2021/3/1.
//

import Foundation

struct FlickrPhotoResponse : Decodable{
    var photos:FlickerPhotosModel;
    var stat:String;
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // MARK: - Creating, Copying, and Dellocating method

    //================================================================================
    //
    //================================================================================
    init(from decoder: Decoder) throws {
            
        enum CodingKeys: CodingKey {
               case photos, stat
        }
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        photos = try container.decode(FlickerPhotosModel.self, forKey: .photos);
        stat = try container.decode(String.self, forKey: .stat);
    }
    
}
