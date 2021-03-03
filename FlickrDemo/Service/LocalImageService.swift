//
//  LocalImageService.swift
//  FlickrDemo
//
//  Created by 林紘毅 on 2021/3/2.
//

import UIKit

class LocalImageService: NSObject {
    
    static let sharedInstance = LocalImageService();
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // MARK: - Instance Method
    
    //================================================================================
    //
    //================================================================================
    func saveImage(image: UIImage, fileName:String) -> Bool {
    
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
            return false;
        }
        
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return false;
        }
       
        do {
            try data.write(to: directory.appendingPathComponent(fileName)!)
            return true;
        }
        catch {
            print(error.localizedDescription)
            return false;
        }
    }
    
    
    //================================================================================
    //
    //================================================================================
    func getSavedImage(named: String) -> UIImage?
    {
        var image:UIImage? = nil;
        
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        {
            image = UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        
        return image;
    }
    
    
    //================================================================================
    //
    //================================================================================
    func removeImage(fileName:String) {
       
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as URL else {
            return;
        }
       
        do
        {
            try FileManager.default.removeItem(at: directory.appendingPathComponent(fileName));
        }
        catch
        {
            print(error.localizedDescription)
        }
    }
    
}
