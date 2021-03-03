//
//  StorageService.swift
//  FlickrDemo
//
//  Created by 林紘毅 on 2021/3/2.
//

import UIKit

class StorageService: NSObject {
    
    static let sharedInstance = StorageService();
    
    private var allData:[FlickrFavoriteModel]?;
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - Creating, Copying, and Dellocating Object method

    //================================================================================
    //
    //================================================================================
    public override init()
    {
        super.init()
        
        //////////////////////////////////////////////////

        self.allData = self.loadDataFromUserDefaults();
    }
    
    
    
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - Private method

    //================================================================================
    //
    //================================================================================
    private func loadDataFromUserDefaults() -> [FlickrFavoriteModel]?
    {
        guard let decodedData:Data = UserDefaults.standard.object(forKey: Flickr_StorageKey) as? Data else
        {
            return [];
        }
        
        do
        {
            guard let data = try NSKeyedUnarchiver.unarchivedArrayOfObjects(ofClasses: [FlickrFavoriteModel.self], from: decodedData) as? [FlickrFavoriteModel] else
            {
                return [];
            }
           
            return data;
        }
        catch
        {
            return [];
        }
    }
    
    
    //================================================================================
    //
    //================================================================================
    private func writeDataFromUserDefaults()
    {
        guard let _allData = self.allData else {
            return;
        }
        
        
        do
        {
            let encodedData = try NSKeyedArchiver.archivedData(withRootObject: _allData, requiringSecureCoding: true);
            
            UserDefaults.standard.setValue(encodedData, forKey: Flickr_StorageKey);
        }
        catch
        {
            return;
        }
    }
    
    
    
    
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // MARK: - Instance method
    
    //================================================================================
    //
    //================================================================================
    public func addData(data:FlickrFavoriteModel)
    {
        self.allData?.append(data);
        self.writeDataFromUserDefaults();
    }
    
    
    //================================================================================
    //
    //================================================================================
    public func removeData(id:String!)
    {
        guard let _allData = self.allData else {
            return;
        }
        
        //////////////////////////////////////////////////

        var removeIndex = NSNotFound;
        
        for (index, element) in _allData.enumerated()
        {
            
            if(element.id.compare(id) != ComparisonResult.orderedSame)
            {
                continue;
            }
            
            //////////////////////////////////////////////////

            removeIndex = index;
            
            break;
        };
        
        if(removeIndex != NSNotFound)
        {
            self.allData?.remove(at: removeIndex);
        }
        
        self.writeDataFromUserDefaults();
    }
    
    
    //================================================================================
    //
    //================================================================================
    public func allIDs() -> [String]
    {
        guard let _allData = self.allData else {
            return []
        }
        
        return _allData.map{ $0.id };
    }
    
    
    //================================================================================
    //
    //================================================================================
    public func allDatas() -> [FlickrFavoriteModel]
    {
        return self.allData ?? [];
    }
}
