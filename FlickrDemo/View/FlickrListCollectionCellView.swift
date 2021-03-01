//
//  FlickrListCollectionCellView.swift
//  FlickrDemo
//
//  Created by 林紘毅 on 2021/3/1.
//

import UIKit
import SnapKit

class FlickrListCollectionCellView: UICollectionViewCell {

    public var imageView:UIImageView? = UIImageView();
    public var bottomLabel:UILabel? = UILabel();
    

    ////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Creating, Copying, and DellocatingObject method

    //================================================================================
    //
    //================================================================================
    override init(frame: CGRect) {
    
        super.init(frame: frame)
 
        //////////////////////////////////////////////////

        guard let _imageView = self.imageView else {
            return;
        }
        
     
        self.addSubview(_imageView);
        
        //////////////////////////////////////////////////

        guard let _bottomLabel = self.bottomLabel else {
            return;
        }
  
        self.addSubview(_bottomLabel);
    }
    
    
    
    //================================================================================
    //
    //================================================================================
    required init?(coder: NSCoder) {
        super.init(coder: coder);
    }
    
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Layout of SubView

    //================================================================================
    //
    //================================================================================
    override func layoutSubviews() {
        super.layoutSubviews();

        //////////////////////////////////////////////////

        self.imageView?.snp.makeConstraints { (imageView) -> Void in
 
            imageView.width.equalTo(self.snp.width).offset(-10);
            imageView.height.equalTo((self.bounds.size.height-10)*0.8);
            imageView.left.equalTo(self.snp.left).offset(5);
            imageView.top.equalTo(self.snp.top).offset(5);
        }
        
        //////////////////////////////////////////////////

        self.bottomLabel?.snp.makeConstraints { (bottomLabel) -> Void in
            
            bottomLabel.left.equalTo(self.snp.left).offset(5);
            bottomLabel.width.equalTo(self.snp.width).offset(-10);
            bottomLabel.height.equalTo((self.bounds.size.height-10)*0.2);
            bottomLabel.bottom.equalTo(self.snp.bottom).offset(-5);
        }
    }

    
    
    
    
    
}
