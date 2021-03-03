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
    public var favoriteButton:UIButton? = UIButton();
    
    private var imageLoadBusyIndicatorView: UIActivityIndicatorView? = UIActivityIndicatorView();
    

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
        
        //////////////////////////////////////////////////

        guard let _imageLoadBusyIndicatorView = self.imageLoadBusyIndicatorView else {
            return;
        }
  
        _imageView.addSubview(_imageLoadBusyIndicatorView);
        
        //////////////////////////////////////////////////

        guard let _favoriteButton = self.favoriteButton else {
            return;
        }
        
        
        _favoriteButton.setImage(UIImage(systemName: "star"), for: .normal);
        
        self.addSubview(_favoriteButton);
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
        
        //////////////////////////////////////////////////

        self.imageLoadBusyIndicatorView?.snp.makeConstraints { (imageLoadBusyIndicatorView) -> Void in
            
            guard let _imageView = self.imageView else
            {
                return;
            }
            
            imageLoadBusyIndicatorView.center.equalTo(_imageView.snp.center);
            imageLoadBusyIndicatorView.width.equalTo(FLVC_ImageLoadBusyIndicatorViewSize);
            imageLoadBusyIndicatorView.height.equalTo(FLVC_ImageLoadBusyIndicatorViewSize);
        }
        
        //////////////////////////////////////////////////

        self.favoriteButton?.snp.makeConstraints { (favoriteButton) -> Void in
            
    
            favoriteButton.top.equalTo(self.snp.top).offset(8);
            favoriteButton.right.equalTo(self.snp.right).offset(-8);
            favoriteButton.width.equalTo(FLVC_FavoriteButtonSize);
            favoriteButton.height.equalTo(FLVC_FavoriteButtonSize);
        }
        
    }
    
    
    
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - Instance method

    //================================================================================
    //
    //================================================================================
    public func showImageLoading()
    {
        self.imageLoadBusyIndicatorView?.startAnimating();
    }
    
    
    //================================================================================
    //
    //================================================================================
    public func hideImageLoading()
    {
        self.imageLoadBusyIndicatorView?.stopAnimating();
    }
    
    
    //================================================================================
    //
    //================================================================================
    public func updateFavoriteButtonImage(favorite:Bool)
    {
        if(favorite == true)
        {
            self.favoriteButton?.setImage(UIImage(systemName: "star.fill"), for: .normal);
        }
        else
        {
            self.favoriteButton?.setImage(UIImage(systemName: "star"), for: .normal)
        }
    }
}
