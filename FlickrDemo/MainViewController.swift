//
//  MainViewController.swift
//  FlickrDemo
//
//  Created by 林紘毅 on 2021/2/28.
//

import UIKit
import SnapKit

////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: - Protocol

protocol MainViewControllerDelegate {
    func mainViewControllerDidSearch(mainViewController:MainViewController, keyword:String, countOfPage:Int);
}





////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: - Class

class MainViewController: UIViewController, UITextFieldDelegate {
    
    public var delegate : MainViewControllerDelegate?;
    
    private var keywordTextField : UITextField?;
    private var perPageTextField : UITextField?;
    private var searchButton : UIButton?;
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - Responding to View's Event
    
    //================================================================================
    //
    //================================================================================
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //////////////////////////////////////////////////
        
        
        self.navigationItem.title = MVC_MLS_MLS_SearchInputPage;
    }
    
    
    //================================================================================
    //
    //================================================================================
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
        //////////////////////////////////////////////////
        
        self.createMainUI();
        self.registerNotification();
    }
    
    
    //================================================================================
    //
    //================================================================================
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        
        //////////////////////////////////////////////////
        
        self.removeMainUI();
        self.unRegisterNotification();
    }
    
    
    
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - Layout SubView
    
    //================================================================================
    //
    //================================================================================
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews();
        
        //////////////////////////////////////////////////
        
        
        self.keywordTextField?.snp.makeConstraints { (textField) -> Void in
            textField.width.equalTo(self.view.frame.size.width-MVC_ContentEdgeInsets.left-MVC_ContentEdgeInsets.right);
            textField.height.equalTo(MVC_TextFieldHeight);
            textField.centerX.equalToSuperview();
            textField.centerY.equalTo(self.view.center.y*0.4);
        }
        
        //////////////////////////////////////////////////
        
        self.perPageTextField?.snp.makeConstraints { (textField) -> Void in
            
            guard let keywordTextField = self.keywordTextField else {
                return;
            }
            
            textField.size.equalTo(keywordTextField.snp.size);
            textField.top.equalTo(keywordTextField.snp.bottom).offset(MVC_TextFieldHeight);
            textField.centerX.equalToSuperview();
        }
        
        //////////////////////////////////////////////////
        
        self.searchButton?.snp.makeConstraints { (button) -> Void in
            
            guard let perPageTextField = self.perPageTextField else {
                return;
            }
            
            button.size.equalTo(perPageTextField.snp.size);
            button.top.equalTo(perPageTextField.snp.bottom).offset(MVC_TextFieldHeight);
            button.centerX.equalToSuperview();
        }
    }
    
    
    
    
    
    
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - Private UI method
    
    //================================================================================
    //
    //================================================================================
    private func createMainUI()
    {
        self.keywordTextField = UITextField();
        
        guard let keywordTextField = self.keywordTextField else {
            return;
        }
        #if DEBUG
        keywordTextField.text = "dog";
        #endif
        keywordTextField.placeholder = MVC_MLS_Keyword;
        keywordTextField.textAlignment = NSTextAlignment.center;
        keywordTextField.layer.borderWidth = 1.0;
        keywordTextField.layer.cornerRadius = 2.0;
        keywordTextField.layer.borderColor = UIColor.darkGray.cgColor;
        
        self.view.addSubview(keywordTextField);
        
        //////////////////////////////////////////////////
        
        self.perPageTextField = UITextField();
        
        guard let perPageTextField = self.perPageTextField else {
            return;
        }
        
        perPageTextField.delegate = self;
        
        #if DEBUG
        perPageTextField.text = "10";
        #endif
        
        perPageTextField.placeholder = MVC_MLS_NumberOfPage;
        perPageTextField.textAlignment = NSTextAlignment.center;
        perPageTextField.keyboardType = UIKeyboardType.numberPad;
        perPageTextField.layer.borderWidth = 1.0;
        perPageTextField.layer.cornerRadius = 2.0;
        perPageTextField.layer.borderColor = UIColor.darkGray.cgColor;
        
        self.view.addSubview(perPageTextField);
        
        //////////////////////////////////////////////////
        
        self.searchButton = UIButton();
        
        guard let searchButton = self.searchButton else {
            return;
        }
        
        searchButton.setTitle(MVC_MLS_Search, for: UIControl.State.normal);
        searchButton.titleLabel?.textColor = UIColor.white;
        self.updateSearchButtonEnable();
        
        searchButton.addTarget(self, action: #selector(requestSendSearch), for: UIControl.Event.touchUpInside);
        self.view.addSubview(searchButton);
    }
    
    
    //================================================================================
    //
    //================================================================================
    private func removeMainUI()
    {
        self.keywordTextField?.removeFromSuperview();
        self.keywordTextField = nil;
        
        self.perPageTextField?.removeFromSuperview();
        self.perPageTextField = nil;
        
        self.searchButton?.removeTarget(self, action: #selector(requestSendSearch), for: UIControl.Event.touchUpInside);
    }
    
    
    //================================================================================
    //
    //================================================================================
    private func updateSearchButtonEnable()
    {
        self.searchButton?.isEnabled = false;
        self.searchButton?.backgroundColor = UIColor.lightGray;
        
        guard let countOfPage = Int(self.perPageTextField?.text ?? "") else {
            return;
        }
        
        //////////////////////////////////////////////////
        
        guard let keyword = self.keywordTextField?.text else {
            return;
        }
        
        if(countOfPage > 0 && keyword.count>0)
        {
            self.searchButton?.isEnabled = true;
            self.searchButton?.backgroundColor = UIColor.blue;
        }
    }
    
    
    
    
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - Private Receive Notification method
    
    //================================================================================
    //
    //================================================================================
    func registerNotification()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldEditingDidChange(_:)), name: UITextField.textDidChangeNotification, object: nil);
    }
    
    
    //================================================================================
    //
    //================================================================================
    func unRegisterNotification()
    {
        NotificationCenter.default.removeObserver(self);
    }
    
    
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - Private Notification  method
    
    //================================================================================
    //
    //================================================================================
    @objc func textFieldEditingDidChange(_ sender: Any) {
        self.updateSearchButtonEnable();
    }
    
    
    
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - Private SendDelegate Method
    
    //================================================================================
    //
    //================================================================================
    @objc private func requestSendSearch()
    {
        guard let _delegate = self.delegate else {
            return;
        }
        
        //////////////////////////////////////////////////
        
        guard let _countOfPage = self.perPageTextField?.text else {
            return;
        }
        
        
        //////////////////////////////////////////////////
        
        guard let _keyword = self.keywordTextField?.text else {
            return;
        }
        
        //////////////////////////////////////////////////
        
        guard let count:Int = Int(_countOfPage) else
        {
            
            return;
        }
        
        _delegate.mainViewControllerDidSearch(mainViewController: self, keyword: _keyword, countOfPage:count);
    }
    
    
    
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // MARK: - UITextFieldDelegate Method
    
    //================================================================================
    //
    //================================================================================
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var result = true;
        
        if (textField == self.perPageTextField)
        {
            let allowedCharacters = CharacterSet.decimalDigits;
            
            let characterSet = CharacterSet(charactersIn: string);
            
            result = allowedCharacters.isSuperset(of: characterSet);
        }
        
        return result;
    }
}
