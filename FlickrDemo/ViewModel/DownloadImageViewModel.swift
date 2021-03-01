//
//  DownloadImageViewModel.swift
//  FlickrDemo
//
//  Created by 林紘毅 on 2021/3/1.
//

import UIKit

class DownloadImageViewModel: ImageCachedViewModel {

    static let sharedInstance = DownloadImageViewModel()
    
    private var operationQueue:OperationQueue?;

    ////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // MARK: - Creating, Copying, and Dellocating Object
    
    //================================================================================
    //
    //================================================================================
    override init() {
        super.init();
        
        //////////////////////////////////////////////////

        self.operationQueue = OperationQueue();
        self.operationQueue?.maxConcurrentOperationCount = FlickrDemo_ImageCachedCount;

    }
    
    
    //================================================================================
    //
    //================================================================================
    public func loadImageFromModel(model:FlickrPhotoModel, completion:@escaping (_ image:UIImage?) -> ())
    {
        self.operationQueue?.addOperation {

            self.imageFromKey(key: model.id) { (keepImage) in

                if let _keepImage = keepImage
                {
                    DispatchQueue.main.async {
                        completion(_keepImage);
                    }
                }
                else
                {
                    let urlstring = FlickrPhotoURL + model.server  + "/" + model.id + "_" + model.secret + "_w.jpg";
                    
                    
                    guard let url = URL(string: urlstring) else
                    {
                        DispatchQueue.main.async {
                            completion(nil);
                        }
                        
                        return;
                    }
                    
                    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                        if let data = data, let loadedImage = UIImage(data: data) {
                            
                            self.setImage(image: loadedImage, with: model.id);
                            
                            DispatchQueue.main.async {
                                completion(loadedImage);
                            }
                        }
                    }
                    task.resume();
                }
            }
        }
    }

    
    //================================================================================
    //
    //================================================================================
    public func loadImageFromModel2(model:FlickrPhotoModel, completion:@escaping () -> ())
    {
        completion();
    }
}
