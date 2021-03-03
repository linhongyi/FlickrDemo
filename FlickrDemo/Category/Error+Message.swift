//
//  Error+Message.swift
//  FlickrDemo
//
//  Created by 林紘毅 on 2021/3/4.

import Foundation

extension Error{
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - Instance method

    //================================================================================
    //
    //================================================================================
    func alertMessage() -> String! {
        
        var message = self.localizedDescription
        
        let nsError = self as NSError
        
        if(nsError.localizedDescription.count>0 ||
            nsError.localizedFailureReason?.count ?? 0>0)
        {
            message = String(format: "[%@:%ld]\n",nsError.domain,nsError.code)
        }
        
        if let localizedFailureReason = nsError.localizedFailureReason{
            message.append(localizedFailureReason)
        }
        else
        {
            message.append(self.localizedDescription)
        }
        
        return message
    }
}
