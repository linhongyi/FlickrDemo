//
//  FlickrPhotoModel.swift
//  FlickrDemo
//
//  Created by 林紘毅 on 2021/3/1.
//

import Foundation

//{"photos":{"page":1,"pages":1905,"perpage":100,"total":"190467","photo":[{"id":"50991321487","owner":"14136614@N03","secret":"a3e1af0cc9","server":"65535","farm":66,"title":"Pup Star by Wetiko","ispublic":1,"isfriend":0,"isfamily":0}

struct FlickrPhotoModel : Decodable{
    var id:String;
    var owner:String;
    var secret:String;
    var server:String;
    var farm:Int;
    var title:String;
    var ispublic:Int;
    var isfriend:Int;
    var isfamily:Int;
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // MARK: - Creating, Copying, and Dellocating method

    //================================================================================
    //
    //================================================================================
    init(from decoder: Decoder) throws {
            
        enum CodingKeys: CodingKey {
               case id, owner, secret, server, farm, title, ispublic, isfriend, isfamily
        }
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id);
        owner = try container.decode(String.self, forKey: .owner);
        secret = try container.decode(String.self, forKey: .secret);
        server = try container.decode(String.self, forKey: .server);
        farm = try container.decode(Int.self, forKey: .farm);
        title = try container.decode(String.self, forKey: .title);
        ispublic = try container.decode(Int.self, forKey: .ispublic);
        isfriend = try container.decode(Int.self, forKey: .isfriend);
        isfamily = try container.decode(Int.self, forKey: .isfamily);
    }
}
