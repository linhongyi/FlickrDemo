//
//  SectionViewModel.swift
//  FlickrDemo
//
//  Created by 林紘毅 on 2021/3/1.
//

import Foundation

class SectionViewModel {
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - Property
    internal var sectionModelsForDefault:Array = Array<SectionModel>()
    internal var sectionModelsForFilter:Array = Array<SectionModel>()
    
    
    
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // MARK: - Instance Method
    
    //================================================================================
    //
    //================================================================================
    func sectionModel(at index:Int, forFilter:Bool)->SectionModel?{
        var targetSectionModel:SectionModel?
        
        repeat{
            
            let targetSectionModels = self.sectionModels(forFilter: forFilter)
             
            if(targetSectionModels.count<=index)
            {
                break
            }
            
            targetSectionModel = targetSectionModels[index]
        } while(0 != 0)
        
        return targetSectionModel
    }
    
    
    //================================================================================
    //
    //================================================================================
    func sectionModels(forFilter:Bool)-> Array<SectionModel>{
        return (forFilter==true) ? self.sectionModelsForFilter : self.sectionModelsForDefault
    }
    
    
    //================================================================================
    //
    //================================================================================
    func numberSections(forFilter:Bool) -> Int {
        return self.sectionModels(forFilter: forFilter).count;
    }
    
    
    //================================================================================
    //
    //================================================================================
    func numberOfRowsInSection(section:Int, forFilter:Bool) -> Int {
        
        var numberOfRows:Int = 0
        
        repeat
        {
            let sectinModels = self.sectionModels(forFilter: forFilter)
            
            if(section>=sectinModels.count)
            {
                break
            }
            
            //////////////////////////////////////////////////

            numberOfRows = sectinModels[section].rowModels.count;
            
        }while (0 != 0)
        
        return numberOfRows
    }
    
    
    //================================================================================
    //
    //================================================================================
    func rowModelAtIndexPath(indexPath:IndexPath, forFilter:Bool)->RowModel?{
        
        var rowModel:RowModel?
        
        repeat
        {
            let sectinModels = self.sectionModels(forFilter: forFilter)
                      
            
            if(indexPath.section>=sectinModels.count)
            {
                break
            }
            
            //////////////////////////////////////////////////

            let sectionModel = sectinModels[indexPath.section]
            
            if(indexPath.row>=sectionModel.rowModels.count)
            {
                break;
            }
            
            rowModel = sectionModel.rowModels[indexPath.row]
        }while (0 != 0)
        
        return rowModel
    }
    
    
    //================================================================================
    //
    //================================================================================
    func removeRowModelAtIndexPath(indexPath:IndexPath, forFilter:Bool)->Bool
    {
        var result:Bool = false
        
        repeat
        {
            let rowModel = self.rowModelAtIndexPath(indexPath: indexPath, forFilter: forFilter)
            
            if(rowModel==nil)
            {
                break
            }
            
            let sectionModel = self.sectionModel(at: indexPath.section, forFilter: forFilter)
            
            if(sectionModel==nil)
            {
                break
            }
            
            sectionModel?.rowModels.remove(at: indexPath.row)
            
            result = true
            
        } while(0 != 0)
        
        return result
    }
}
