//
//  InitialViewController.swift
//  improve-talking
//
//  Created by Sunny Ouyang on 10/9/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {

    //MARK: VARIABLES
    
    //MARK: OUTLETS
    var iconImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "toast")
        return imageView
    }()
    
    var appNameLabel: UILabel = {
        var label = UILabel()
        label.textColor = #colorLiteral(red: 0.2323930722, green: 0.2516170577, blue: 0.2795447335, alpha: 1)
        label.text = "Toast"
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 70)
        label.layer.shadowColor = #colorLiteral(red: 0.231372549, green: 0.2509803922, blue: 0.2784313725, alpha: 1)
        label.layer.shadowRadius = 2.0
        label.layer.shadowOpacity = 1.0
        label.layer.shadowOffset = CGSize(width: 0, height: 2)
        label.layer.masksToBounds = false
        return label
    }()
    
    var usernameTextField: UITextField = {
        var textField = UITextField()
        textField.textColor = #colorLiteral(red: 0.231372549, green: 0.2509803922, blue: 0.2745098039, alpha: 1)
        textField.placeholder = "username"
        textField.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 22)
        textField.backgroundColor = UIColor.white
        textField.layer.cornerRadius = 18
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
        textField.leftViewMode = .always
        return textField
    }()
    
    var passwordTextField: UITextField = {
        var textField = UITextField()
        textField.textColor = #colorLiteral(red: 0.231372549, green: 0.2509803922, blue: 0.2745098039, alpha: 1)
        textField.layer.cornerRadius = 18
        textField.backgroundColor = UIColor.white
        textField.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 22)
        textField.placeholder = "password"
        textField.isSecureTextEntry = true
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
        textField.leftViewMode = .always
        return textField
    }()
    
    var continueButton: UIButton = {
        var button = UIButton()
        button.layer.cornerRadius = 25
        button.backgroundColor = #colorLiteral(red: 1, green: 0.7137254902, blue: 0.03137254902, alpha: 1)
        button.setTitle("Continue", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        
//        button.layer.shadowColor = #colorLiteral(red: 0.231372549, green: 0.2509803922, blue: 0.2784313725, alpha: 1)
//        button.layer.shadowRadius = 2.0
//        button.layer.shadowOpacity = 1.0
//        button.layer.shadowOffset = CGSize(width: 0, height: 1)
//        button.layer.masksToBounds = false
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 25)
        return button
    }()
    
    //MARK: FUNCTIONS
    
    @objc private func moveToHome() {
        let homeVC = HomeViewController()
        self.present(homeVC, animated: true, completion: nil)
    }
    
    private func addOutlets() {
        self.view.addSubview(iconImageView)
        self.view.addSubview(appNameLabel)
        self.view.addSubview(usernameTextField)
        self.view.addSubview(passwordTextField)
        self.view.addSubview(continueButton)
    }
    
    private func setConstraints() {
        
        let iconHeightWidth = UIScreen.main.bounds.height * 0.17
        let iconTopDistance = UIScreen.main.bounds.height * 0.095
        let textFieldWidth = UIScreen.main.bounds.width * 0.616
        let textFieldTopDistance = UIScreen.main.bounds.height * 0.08
        
        
        iconImageView.snp.makeConstraints { (make) in
            make.height.equalTo(iconHeightWidth)
            make.width.equalTo(iconHeightWidth)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(iconTopDistance)
        }
        
        appNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(iconImageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        usernameTextField.snp.makeConstraints { (make) in
            make.width.equalTo(textFieldWidth)
            make.height.equalTo(45)
            make.top.equalTo(appNameLabel.snp.bottom).offset(textFieldTopDistance)
            make.centerX.equalToSuperview()
        }
        
        passwordTextField.snp.makeConstraints { (make) in
            make.width.equalTo(textFieldWidth)
            make.height.equalTo(45)
            make.top.equalTo(usernameTextField.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
        }
        
        continueButton.snp.makeConstraints { (make) in
            make.width.equalTo(textFieldWidth)
            make.centerX.equalToSuperview()
            make.height.equalTo(65)
            make.top.equalTo(passwordTextField.snp.bottom).offset(45)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        continueButton.addTarget(self, action: #selector(moveToHome), for: .touchUpInside)
        hideKeyboardWhenTappedAround()
        view.backgroundColor = #colorLiteral(red: 0.934114673, green: 0.9433633331, blue: 0.9433633331, alpha: 1)
        addOutlets()
        setConstraints()
    }

    

}
