//
//  ImageCachedService.swift
//  FlickrDemo
//
//  Created by 林紘毅 on 2021/3/1.
//

import UIKit

class ImageCachedService: NSObject {

    ////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - Property
    
    public var maxLimit:NSInteger = FlickrDemo_ImageCachedCount;
    private var imageDictionary : Dictionary<String, UIImage>? = Dictionary();
    private var readWriteQueue: OperationQueue = OperationQueue();
    
    
    
    
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////

    // MARK: - Creating, Copying, and Dellocating method

    //================================================================================
    //
    //================================================================================
    public override init()
    {
        super.init()
        
        self.readWriteQueue.maxConcurrentOperationCount = 1
    }
    
    
    
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // MARK: - Instance method

    //================================================================================
    //
    //================================================================================
    func setImage(image:UIImage, with key:String) {
        
        self.readWriteQueue.addOperation {
            if(key.count>0)
            {
                if(self.imageDictionary?.count ?? 0>self.maxLimit)
                {
                    if let removedKey = self.imageDictionary?.keys.first{
                 
                        self.imageDictionary?.removeValue(forKey: removedKey)
                    }
                }
                
                self.imageDictionary?[key] = image
            }
        }
        
    }
    
    
    //================================================================================
    //
    //================================================================================
    func imageFromKey(key:String ,completion:@escaping(_ image:UIImage?) -> ()){
        self.readWriteQueue.addOperation {
            let image = self.imageDictionary?[key]
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
    
    
    //================================================================================
    //
    //================================================================================
    func removeImageByKey(key:String){
        
        self.readWriteQueue.addOperation {
            self.imageDictionary?.removeValue(forKey: key)
        }
        
    }
    
    
    //================================================================================
    //
    //================================================================================
    func removeAllImage()
    {
        self.readWriteQueue.addOperation {
            self.imageDictionary?.removeAll()
        }
    }
    
}
