//
//  InitialViewController.swift
//  improve-talking
//
//  Created by Sunny Ouyang on 10/9/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import UIKit

// TODO: Remove print statements on 1.0 production release

class InitialViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.934114673, green: 0.9433633331, blue: 0.9433633331, alpha: 1)
        hideKeyboardWhenTappedAround()
        addSubviews()
        setConstraints()
    }
    
    // MARK: - Private
    
    /// Flag which indicates whether a login request should be attempted.
    private var shouldAttemptLogin = false {
        didSet {
            guard shouldAttemptLogin == true else { return }
            DispatchQueue.main.async {
                self.loginUser()
            }
        }
    }
    
    private var iconImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "toast")
        return imageView
    }()
    
    private var appNameLabel: UILabel = {
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
    
    // TODO: Refactor repeated code in textfield closures. Follow DRY principle.
    private var usernameTextField: UITextField = {
        var textField = UITextField()
        textField.autocapitalizationType = .none
        textField.textColor = #colorLiteral(red: 0.231372549, green: 0.2509803922, blue: 0.2745098039, alpha: 1)
        textField.placeholder = "username"
        textField.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 22)
        textField.backgroundColor = UIColor.white
        textField.layer.cornerRadius = 18
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        return textField
    }()
    
    // TODO: Refactor repeated code in textfield closures. Follow DRY principle.
    private var passwordTextField: UITextField = {
        var textField = UITextField()
        textField.textColor = #colorLiteral(red: 0.231372549, green: 0.2509803922, blue: 0.2745098039, alpha: 1)
        textField.layer.cornerRadius = 18
        textField.backgroundColor = UIColor.white
        textField.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 22)
        textField.placeholder = "password"
        textField.isSecureTextEntry = true
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        return textField
    }()
    
    private var continueButton: UIButton = {
        var button = UIButton()
        button.layer.cornerRadius = 25
        button.backgroundColor = #colorLiteral(red: 1, green: 0.7137254902, blue: 0.03137254902, alpha: 1)
        button.isEnabled = false
        button.alpha = 0.3
        button.setTitle("Continue", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 25)
        button.addTarget(self, action: #selector(continueButtonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    private var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicator.activityIndicatorViewStyle = .white
        indicator.isHidden = true
        return indicator
    }()
    
    // MARK: Methods
    
    private func addSubviews() {
        self.view.addSubview(iconImageView)
        self.view.addSubview(appNameLabel)
        self.view.addSubview(usernameTextField)
        self.view.addSubview(passwordTextField)
        self.view.addSubview(continueButton)
        continueButton.addSubview(activityIndicator)
    }
    
    private func setConstraints() {
        let iconHeightWidth = UIScreen.main.bounds.height * 0.17
        let iconTopDistance = UIScreen.main.bounds.height * 0.095
        let textFieldWidth = UIScreen.main.bounds.width * 0.616
        let textFieldHeight = UIScreen.main.bounds.height * 0.06
        let textFieldTopDistance = UIScreen.main.bounds.height * 0.08
        let buttonHeight = UIScreen.main.bounds.height * 0.088
        
        iconImageView.snp.makeConstraints { (make) in
            make.height.width.equalTo(iconHeightWidth)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(iconTopDistance)
        }
        
        appNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(iconImageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        usernameTextField.snp.makeConstraints { (make) in
            make.width.equalTo(textFieldWidth)
            make.height.equalTo(textFieldHeight)
            make.top.equalTo(appNameLabel.snp.bottom).offset(textFieldTopDistance)
            make.centerX.equalToSuperview()
        }
        
        passwordTextField.snp.makeConstraints { (make) in
            make.width.equalTo(textFieldWidth)
            make.height.equalTo(textFieldHeight)
            make.top.equalTo(usernameTextField.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
        }
        
        continueButton.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: textFieldWidth, height: 65.0))
            make.centerX.equalToSuperview()
            make.height.equalTo(buttonHeight)
            make.top.equalTo(passwordTextField.snp.bottom).offset(45)
        }
    
        activityIndicator.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
        }
    }

    private func presentHomeViewController() {
        let homeViewController = HomeViewController()
        navigationController?.pushViewController(homeViewController, animated: true)
    }
    
    private func presentAlert(withTitle title: String, message: String?, handler: ((UIAlertAction) -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: handler)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func showActivityIndicator() {
        continueButton.setTitle(nil, for: .normal)
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideActivityIndicator() {
        continueButton.setTitle("Continue", for: .normal)
        activityIndicator.stopAnimating()
    }
    
    private func cacheUser(_ user: User) {
        let userFileURL = FileManager.default
            .urls(for: .cachesDirectory, in: .allDomainsMask)
            .first!
            .appendingPathComponent("user.plist")
        user.dictionary.write(to: userFileURL, atomically: true)
        KeychainHelper.save(value: user.token, as: .authToken)
        KeychainHelper.save(value: "\(user.id)", as: .userID)
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
    }
    
    private func loginUser() {
        // we can safely force unwrap text from textfields b'c 'continue' button is only enabled
        // when textfields have valid text.
        ToastAPI.login(withUsername: usernameTextField.text!, password: passwordTextField.text!) { (json, error, statusCode) in
            print("\n* InitialViewController -> loginUser(): Will Attempt login")
            guard error == nil else {
                print(error ?? "undefined error")
                DispatchQueue.main.async {
                    self.hideActivityIndicator()
                    self.presentAlert(withTitle: "Oops", message: "Something went wrong on our side. Please try again later", handler: nil)
                }
                return
            }
            guard let status = statusCode,
                status != 401 else {
                    let unauthorizedMessage = json?["error"] as? String ?? "Incorrect username or password"
                    print("\n* InitialViewController -> loginUser(): \(unauthorizedMessage)")
                    DispatchQueue.main.async {
                        self.hideActivityIndicator()
                        self.presentAlert(withTitle: "Incorrect Password",
                                          message: "This username is already registered. Please enter the correct password or create a new account",
                                          handler: nil)
                    }
                    return
            }
            guard let json = json,
                let user = User(json: json) else {
                    print("\n* InitialViewController -> loginUser(): Invalid json")
                    DispatchQueue.main.async {
                        self.hideActivityIndicator()
                        self.presentAlert(withTitle: "Oops", message: "Something went wrong on our side. Please try again later", handler: nil)
                    }
                    return
            }
            print("\n* InitialViewController -> loginUser(): Did login user: \(user.dictionary)")
            self.cacheUser(user)
            DispatchQueue.main.async {
                self.presentHomeViewController()
            }
        }
    }
    
    @objc private func continueButtonPressed(_ sender: UIButton) {
        // Attempt to create a new account, if username is already registered we update 'shouldLogin' flag
        // inorder to attempt login with provided credentials
        showActivityIndicator()
        // we can safely force unwrap text from textfields b'c 'continue' button is only enabled
        // when textfields have valid text.
        ToastAPI.signUp(withUsername: usernameTextField.text!, password: passwordTextField.text!) { (json, error, statusCode) in
            guard error == nil else {
                print(error ?? "undefined error")
                DispatchQueue.main.async {
                    self.hideActivityIndicator()
                    self.presentAlert(withTitle: "Oops", message: "Something went wrong on our side. Please try again later", handler: nil)
                }
                return
            }
            guard let status = statusCode,
                status != 422 else {
                    print("\n* InitialViewController -> continueButtonPressed(_:): Should login")
                    self.shouldAttemptLogin = true
                    return
            }
            guard let json = json, let user = User(json: json) else {
                print("\n* InitialViewController -> continueButtonPressed(_:): Invalid json")
                DispatchQueue.main.async {
                    self.presentAlert(withTitle: "Oops", message: "Something went wrong on our side. Please try again later", handler: nil)
                }
                return
            }
            print("\n* InitialViewController -> continueButtonPressed(_): Did create user: \(user.dictionary)")
            self.cacheUser(user)
            DispatchQueue.main.async {
                self.presentAlert(withTitle: "New account created",
                                  message: "Remember your username and password. There is no password recovery.") { _ in
                                    self.presentHomeViewController()
                }
            }
        }
    }
    
    @objc private func textFieldEditingChanged(_ textField: UITextField) {
        // Check for valid entries in both textfields in order to enable 'continue' button
        let isUsernameVaild = usernameTextField.text != nil && !usernameTextField.text!.isEmptyOrWhitespace
        let isPasswordVaild = passwordTextField.text != nil && !passwordTextField.text!.isEmptyOrWhitespace
        guard isUsernameVaild && isPasswordVaild else {
            continueButton.isEnabled = false
            continueButton.alpha = 0.3
            return
        }
        continueButton.isEnabled = true
        continueButton.alpha = 1.0
    }
}
