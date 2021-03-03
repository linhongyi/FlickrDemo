//
//  FlickrListViewModel.swift
//  FlickrDemo
//
//  Created by 林紘毅 on 2021/3/1.
//

import UIKit

class FlickrListViewModel : SectionViewModel {
    
    public var reloadDataCompleted : (()->())?;
    
    public var page:Int = Flickr_StartPage;
    public var countPerPage:Int = 10;
    public var keyword:String = "";
    
    private var total:Int = 0;
    
    

    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - Instance method

    //================================================================================
    //
    //================================================================================
    public func clearAndloadDataFromResponse(flickrPhotoResponse:FlickrPhotoResponse, forFilter:Bool)
    {
        self.removeAllObjects(forFilter: forFilter);
        
        //////////////////////////////////////////////////

        self.total = Int(flickrPhotoResponse.photos.total) ?? 0;
        
        self.appendDataFromResponse(flickrPhotoResponse: flickrPhotoResponse, forFilter: forFilter);
    }
    
    
    //================================================================================
    //
    //================================================================================
    public func appendDataFromResponse(flickrPhotoResponse:FlickrPhotoResponse, forFilter:Bool)
    {
        repeat
        {
            if(flickrPhotoResponse.photos.photo.count<=0)
            {
                break;
            }
            
            //////////////////////////////////////////////////

            let favoriteIds = StorageService.sharedInstance.allIDs();
            
            //////////////////////////////////////////////////

            var sectionModel:SectionModel? = SectionModel();
            
            if(sectionModel==nil)
            {
                break;
            }
  
            //////////////////////////////////////////////////

            for photo in flickrPhotoResponse.photos.photo
            {
                let rowModel:FlickrFavoriteRowModel? = FlickrFavoriteRowModel();
                
                guard let _rowModel = rowModel else {
                    return;
                }
                
                if(favoriteIds.firstIndex(of: photo.id) != nil)
                {
                    _rowModel.favorite = true;
                }
                
                _rowModel.id = photo.id;
                _rowModel.text = photo.title;
                _rowModel.object = photo as AnyObject;
     
                sectionModel?.rowModels.append(_rowModel);
                
                //////////////////////////////////////////////////

                guard let _sectionModel = sectionModel else {
                    return;
                }
                
                if(_sectionModel.rowModels.count%2 == 0)
                {
                    self.sectionModelsForDefault.append(_sectionModel);
                    
                    //////////////////////////////////////////////////

                    sectionModel = SectionModel();
                    
                    if(sectionModel==nil)
                    {
                        break;
                    }
                }
            }
            
            
            //////////////////////////////////////////////////

            // last one
            if(sectionModel?.rowModels.count ?? 0>0)
            {
                guard let _sectionModel = sectionModel else {
                    return;
                }
                
                if(forFilter==false)
                {
                    self.sectionModelsForDefault.append(_sectionModel);
                }
                else
                {
                    self.sectionModelsForFilter.append(_sectionModel);
                }
                
            }
            
            
            //////////////////////////////////////////////////

            guard let _reloadDataCompleted = self.reloadDataCompleted else {
                return;
            }
            
      
            _reloadDataCompleted();
            
        }while (0 != 0)
    }

    
    //================================================================================
    //
    //================================================================================
    public func supportPageLoad(forFilter: Bool)->Bool
    {
        let arrayOfSectionModel = self.sectionModels(forFilter: forFilter);
        
        // two rowmodels
        var totalCount = arrayOfSectionModel.count*2;
        
        if(arrayOfSectionModel.last?.rowModels.count ?? 0<2)
        {
            totalCount -= 1;
        }
        
        return totalCount<self.total;
    }
    
    
    //================================================================================
    //
    //================================================================================
    public func onFavoriteChanged(image:UIImage?,indexPath:IndexPath, forFilter:Bool) -> Bool
    {
        var result:Bool = false;
        
        guard let rowModel:FlickrFavoriteRowModel = self.rowModelAtIndexPath(indexPath: indexPath, forFilter: forFilter) as? FlickrFavoriteRowModel else
        {
            return result;
        }
        
        result = true;
        
        rowModel.favorite = !rowModel.favorite;
        
        if(rowModel.favorite==true)
        {
            guard let _image = image else {
                return result;
            }
            
            result = LocalImageService.sharedInstance.saveImage(image: _image, fileName: rowModel.id+Flickr_ImageExtension);
              
            if(result==false)
            {
                return result;
            }
            
            StorageService.sharedInstance.addData(data: FlickrFavoriteModel(id: rowModel.id, title: rowModel.text));
        }
        else
        {
            LocalImageService.sharedInstance.removeImage(fileName: rowModel.id+Flickr_ImageExtension);
            
            StorageService.sharedInstance.removeData(id: rowModel.id)
        }
        
        return result;
    }
    
    
    //================================================================================
    //
    //================================================================================
    public func loadLocalFavoriteData(forFilter:Bool)
    {
        repeat
        {
            self.removeAllObjects(forFilter: forFilter);
            
            //////////////////////////////////////////////////

            let datas:[FlickrFavoriteModel] = StorageService.sharedInstance.allDatas();
            
            //////////////////////////////////////////////////

            var sectionModel:SectionModel? = SectionModel();
            
            if(sectionModel==nil)
            {
                break;
            }
  
            //////////////////////////////////////////////////

            for model in datas
            {
                let rowModel:FlickrFavoriteRowModel? = FlickrFavoriteRowModel();
                
                guard let _rowModel = rowModel else {
                    return;
                }
                
                _rowModel.favorite = true;
                _rowModel.id = model.id;
                _rowModel.text = model.title ?? "";
             
                sectionModel?.rowModels.append(_rowModel);
                
                //////////////////////////////////////////////////

                guard let _sectionModel = sectionModel else {
                    return;
                }
                
                if(_sectionModel.rowModels.count%2 == 0)
                {
                    self.sectionModelsForDefault.append(_sectionModel);
                    
                    //////////////////////////////////////////////////

                    sectionModel = SectionModel();
                    
                    if(sectionModel==nil)
                    {
                        break;
                    }
                }
            }
            
            
            //////////////////////////////////////////////////

            // last one
            if(sectionModel?.rowModels.count ?? 0>0)
            {
                guard let _sectionModel = sectionModel else {
                    return;
                }
                
                //////////////////////////////////////////////////

                if(forFilter==true)
                {
                    self.sectionModelsForFilter.append(_sectionModel);
                }
                else
                {
                    self.sectionModelsForDefault.append(_sectionModel);
                }
            }
            
            
            //////////////////////////////////////////////////

            guard let _reloadDataCompleted = self.reloadDataCompleted else {
                return;
            }
            
      
            _reloadDataCompleted();
            
        }while (0 != 0)
    }
    
    
    //================================================================================
    //
    //================================================================================
    public func sortFavoriteDataAndReload(forFilter:Bool)
    {
        var arrayOfSectionModel = self.sectionModelsForDefault;
        
        if(forFilter==true)
        {
            arrayOfSectionModel = self.sectionModelsForFilter;
        }

        for section in 0...arrayOfSectionModel.count-1
        {
            let sectionModel = arrayOfSectionModel[section];
            
            if(sectionModel.rowModels.count>=2)
            {
                continue;
            }
            
            //////////////////////////////////////////////////

            let nextSection = section+1;
            
            if(nextSection>=arrayOfSectionModel.count)
            {
                break;
            }
            
            let nextSectionModel = arrayOfSectionModel[nextSection];
            
            if let candicatedRowModel = nextSectionModel.rowModels.first
            {
                sectionModel.rowModels.append(candicatedRowModel);
                
                nextSectionModel.rowModels.removeFirst();
            }
        }
        
        //////////////////////////////////////////////////

        if let lastSectionModel = arrayOfSectionModel.last
        {
            if(lastSectionModel.rowModels.count<=0)
            {
                arrayOfSectionModel.removeLast();
            }
        }
        
        //////////////////////////////////////////////////

        guard let _reloadDataCompleted = self.reloadDataCompleted else {
            return;
        }
        
        _reloadDataCompleted();
    }
    
    
    //================================================================================
    //
    //================================================================================
    public func updateFavoriteData(forFilter:Bool)
    {
        repeat
        {
            let favoriteIds = StorageService.sharedInstance.allIDs();
            
            if(favoriteIds.count<=0)
            {
                break;
            }
            
            //////////////////////////////////////////////////

            let arrayOfSectionModel = self.sectionModels(forFilter: forFilter);
            
            for sectionModel in arrayOfSectionModel
            {
                for rowModel in sectionModel.rowModels
                {
                    guard let favoriteRowModel = rowModel as? FlickrFavoriteRowModel else
                    {
                        return;
                    }
                    
                    if(favoriteIds.firstIndex(of: favoriteRowModel.id) != nil)
                    {
                        favoriteRowModel.favorite = true;
                    }
                    else
                    {
                        favoriteRowModel.favorite = false;
                    }
                }
            }
            
            //////////////////////////////////////////////////

            guard let _reloadDataCompleted = self.reloadDataCompleted else {
                return;
            }
            
      
            _reloadDataCompleted();
            
        }while (0 != 0)
    }
}
