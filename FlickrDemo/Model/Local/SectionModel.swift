//
//  SectionModel.swift
//  FlickrDemo
//
//  Created by 林紘毅 on 2021/3/1.
//

import Foundation

class SectionModel: NSObject {
    var section:NSInteger = 0;
    var title:NSString = "";
    var rowModels:Array<RowModel> = [];
}
