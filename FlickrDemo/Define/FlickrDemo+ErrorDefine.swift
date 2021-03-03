//
//  FlickrDemo+ErrorDefine.swift
//  FlickrDemo
//
//  Created by 林紘毅 on 2021/3/4.
//

import Foundation

////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: - Enum Define

enum FlickrDemoError: Error {
    case ParameterInvalid
    case APIURL_Illegal
}





////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: Error

extension FlickrDemoError: LocalizedError {
    public var errorDescription: String? {
        
        switch self
        {
        case .APIURL_Illegal:
            return Error_MLS_APIError;
        case .ParameterInvalid:
            return Error_MLS_ParameterError;
        }
    }
}
