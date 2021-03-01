//
//  FlickrListViewModel.swift
//  FlickrDemo
//
//  Created by 林紘毅 on 2021/3/1.
//

import Foundation

class FlickrListViewModel : SectionViewModel {
    
    public var reloadDataCompleted : (()->())?;
    
    public var page:Int = 0;
    public var countPerPage:Int = 10;
    public var keyword:String = "";
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - Instance method

    //================================================================================
    //
    //================================================================================
    public func clearAndloadDataFromResponse(flickrPhotoResponse:FlickrPhotoResponse)
    {
        self.sectionModelsForDefault.removeAll();
        self.sectionModelsForFilter.removeAll();
        
        self.appendDataFromResponse(flickrPhotoResponse: flickrPhotoResponse);
    }
    
    
    //================================================================================
    //
    //================================================================================
    public func appendDataFromResponse(flickrPhotoResponse:FlickrPhotoResponse)
    {
        repeat
        {
            if(flickrPhotoResponse.photos.photo.count<=0)
            {
                break;
            }
            
            //////////////////////////////////////////////////

            var sectionModel:SectionModel? = SectionModel();
            
            if(sectionModel==nil)
            {
                break;
            }
  
            //////////////////////////////////////////////////

            for photo in flickrPhotoResponse.photos.photo
            {
                let rowModel:RowModel? = RowModel();
                
                guard let _rowModel = rowModel else {
                    return;
                }
                
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

            guard let _reloadDataCompleted = self.reloadDataCompleted else {
                return;
            }
            
            _reloadDataCompleted();
            
        }while (0 != 0)
    }

}
