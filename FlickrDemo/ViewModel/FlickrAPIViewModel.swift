//
//  FlickrAPIViewModel.swift
//  FlickrDemo
//
//  Created by 林紘毅 on 2021/3/1.
//

import Foundation
import Alamofire



class FlickrAPIViewModel{
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // MARK: - Instance Method

    func loadPage(keyword:String, page:Int, perPage:Int, completion:@escaping(_ response:FlickrPhotoResponse?, _ error:Error?) -> ()){

//        https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=cac21bb6ea79262d4c33a08a1e496694&text=dog&per_page=10&page=1&format=json&nojsoncallback=1
        
        repeat
        {
            if(page<0 || perPage<0)
            {
                completion(nil,FlickrDemoError.ParameterInvalid);
                
                break;
            }
            
            //////////////////////////////////////////////////

            var url = FlickrPhotoSearchAPI + "&api_key=" + Client_Key;
            
            if(keyword.count>0)
            {
                url += ("&text=" + keyword);
            }
            
            url += ("&page=" + String(page));
            url += ("&per_page=" + String(perPage));
            url += "&format=json&nojsoncallback=1";
            
            print(url);
     
            guard let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                
                completion(nil,FlickrDemoError.APIURL_Illegal);
                
                return;
            }
            
            AF.request(encodedUrl).responseDecodable(of: FlickrPhotoResponse.self) { response in
            
            
                if((response.error) != nil)
                {
                    completion(nil,response.error)
                }
                else
                {
                    completion(response.value,nil)
                }
            }
        }while (0 != 0)
    }
}

