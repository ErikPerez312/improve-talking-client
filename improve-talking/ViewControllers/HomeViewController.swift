//
//  ViewController.swift
//  improve-talking
//
//  Created by Erik Perez on 10/7/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import UIKit
import SnapKit
import AudioToolbox

class HomeViewController: UIViewController, ToastSocketHandlerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.934114673, green: 0.9433633331, blue: 0.9433633331, alpha: 1)
        buildTodayTopic()
        buildChatButton()
        buildSocketHandler()
    }

    // MARK: ToastSocketHandlerDelegate
    
    func didCreateChatRoom(withName roomName: String, token: String) {
        showChatButtonActivityIndicator(false)
        let chatViewController = ChatViewController(roomName: roomName, token: token)
        self.present(chatViewController, animated: true, completion: nil)
    }
    
    // MARK: - Private
    
    private let containerView = UIView()
    private let chatButton = UIButton()
    
    private var chatButtonActicityIndicator: UIActivityIndicatorView?
    private var socketHandler: ToastSocketHandler?
    
    
    private func buildTodayTopic() {
        let containerHeight = UIScreen.main.bounds.height * 0.4755
        let topDistance = UIScreen.main.bounds.height * 0.1358
        
        containerView.backgroundColor = UIColor.white
        containerView.layer.cornerRadius = 15
        containerView.layer.shadowColor = #colorLiteral(red: 0.231372549, green: 0.2509803922, blue: 0.2784313725, alpha: 1)
        containerView.layer.shadowRadius = 2.0
        containerView.layer.shadowOpacity = 1.0
        containerView.layer.shadowOffset = CGSize(width: 0, height: 1)
        containerView.layer.masksToBounds = false

        view.addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.height.equalTo(containerHeight)
            make.leading.trailing.equalToSuperview().inset(40)
            make.top.equalToSuperview().offset(topDistance)

        }
        
        let label = UILabel()
        label.text = "Guidelines"
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 45)
        label.textColor = #colorLiteral(red: 0.231372549, green: 0.2509803922, blue: 0.2784313725, alpha: 1)
        
        containerView.addSubview(label)
        label.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview().offset(15)
            maker.left.equalToSuperview().offset(25)
        }
        
        let firstOrangeBullet = UIView()
        firstOrangeBullet.backgroundColor = #colorLiteral(red: 1, green: 0.7137254902, blue: 0.03137254902, alpha: 1)
        firstOrangeBullet.layer.cornerRadius = 8
        
        containerView.addSubview(firstOrangeBullet)
        firstOrangeBullet.snp.makeConstraints { (maker) in
            maker.top.equalTo(label.snp.bottom).offset(25)
            maker.left.equalToSuperview().offset(25)
            maker.width.height.equalTo(25)
        }
        
        let labelOne = UILabel()
        labelOne.numberOfLines = 0
        labelOne.text = "Topic will be at the top"
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 25)
        
        containerView.addSubview(labelOne)
        labelOne.snp.makeConstraints { (maker) in
            maker.top.equalTo(label.snp.bottom).offset(27)
            maker.left.equalTo(firstOrangeBullet.snp.right).offset(8)
            maker.width.equalToSuperview().inset(25)
        }
        
        let secondOrangeBullet = UIView()
        secondOrangeBullet.backgroundColor = #colorLiteral(red: 1, green: 0.7137254902, blue: 0.03137254902, alpha: 1)
        secondOrangeBullet.layer.cornerRadius = 8
        
        containerView.addSubview(secondOrangeBullet)
        secondOrangeBullet.snp.makeConstraints { (maker) in
            maker.top.equalTo(labelOne.snp.bottom).offset(25)
            maker.left.equalToSuperview().offset(25)
            maker.width.height.equalTo(25)
        }
        
        let labelTwo = UILabel()
        labelTwo.numberOfLines = 0
        labelTwo.text = "End the call at any time"
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 25)
        
        containerView.addSubview(labelTwo)
        labelTwo.snp.makeConstraints { (maker) in
            maker.top.equalTo(labelOne.snp.bottom).offset(27)
            maker.left.equalTo(firstOrangeBullet.snp.right).offset(8)
            maker.width.equalToSuperview().inset(25)
            
        }
        
        let thirdOrangeBullet = UIView()
        thirdOrangeBullet.backgroundColor = #colorLiteral(red: 1, green: 0.7137254902, blue: 0.03137254902, alpha: 1)
        thirdOrangeBullet.layer.cornerRadius = 8
        
        containerView.addSubview(thirdOrangeBullet)
        thirdOrangeBullet.snp.makeConstraints { (maker) in
            maker.top.equalTo(labelTwo.snp.bottom).offset(25)
            maker.left.equalToSuperview().offset(25)
            maker.width.height.equalTo(25)
        }
        
        let labelThree = UILabel()
        labelThree.text = "Have fun!"

        containerView.addSubview(labelThree)
        labelThree.snp.makeConstraints { (maker) in
            maker.top.equalTo(labelTwo.snp.bottom).offset(27)
            maker.left.equalTo(firstOrangeBullet.snp.right).offset(8)
            maker.width.equalToSuperview().inset(25)
        }
    }
    
    private func buildChatButton() {
        chatButton.setImage(#imageLiteral(resourceName: "Phone"), for: .normal)
        chatButton.imageEdgeInsets = UIEdgeInsetsMake(30, 30, 30, 30)
        chatButton.layer.cornerRadius = 62.5
        chatButton.backgroundColor = #colorLiteral(red: 1, green: 0.7137254902, blue: 0.03137254902, alpha: 1)
        chatButton.addTarget(self, action: #selector(chatButtonPressed(_:)), for: .touchUpInside)
        chatButton.adjustsImageWhenHighlighted = false
        
        chatButton.addTarget(self, action: #selector(holdReleaseInside(sender:)), for: .touchUpInside)
        chatButton.addTarget(self, action: #selector(holdReleaseOutside(sender:)), for: .touchUpOutside)
        chatButton.addTarget(self, action: #selector(holdDown), for: .touchDown)
        chatButton.addTarget(self, action: #selector(animateOnTap), for: .touchUpInside)
        
        view.addSubview(chatButton)
        chatButton.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.height.width.equalTo(125)
            maker.top.equalTo(containerView.snp.bottom).offset(50)
        }
        
        let indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        self.chatButtonActicityIndicator = indicator
        indicator.activityIndicatorViewStyle = .white
        indicator.isHidden = true
        
        chatButton.addSubview(indicator)
        indicator.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
        }
    }
    
    private func showChatButtonActivityIndicator(_ flag: Bool) {
        if flag {
            chatButton.imageView?.isHidden = true
            chatButton.isEnabled = false
            chatButtonActicityIndicator?.isHidden = false
            chatButtonActicityIndicator?.startAnimating()
        } else {
            chatButton.imageView?.isHidden = false
            chatButton.isEnabled = true
            chatButtonActicityIndicator?.isHidden = true
            chatButtonActicityIndicator?.startAnimating()
        }
    }
    
    private func buildSocketHandler() {
        // erik c5b5d1647269e44f6d06e3c8a18a8305
        // andrew 1be416e43410ab84746d6b7218a4481b
        let usertoken = "1be416e43410ab84746d6b7218a4481b" // TODO: Fetch user token from keychain
        let handler = ToastSocketHandler(socketURL: ToastAPI.webSocketURL,
                                         socketOrigin: ToastAPI.webSocketOrigin,
                                         userToken: usertoken)
        handler.delegate = self
        self.socketHandler = handler
    }
    
    @objc private func chatButtonPressed(_ sender: UIButton) {
        socketHandler?.chatWithRemoteUser()
        showChatButtonActivityIndicator(true)
    }
    
    @objc private func holdDown(sender:UIButton){
        UIView.animate(withDuration: 0.3,
                       animations: {
                        self.chatButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        })
    }
    
    @objc private func holdReleaseInside(sender:UIButton){
        chatButton.backgroundColor = #colorLiteral(red: 1, green: 0.7137254902, blue: 0.03137254902, alpha: 1)
        UIView.animate(withDuration: 0.2) {
            self.chatButton.transform = CGAffineTransform.identity
        }
        AudioServicesPlayAlertSound(1519)
    }
    
    @objc private func holdReleaseOutside(sender:UIButton){
        chatButton.backgroundColor = #colorLiteral(red: 1, green: 0.7137254902, blue: 0.03137254902, alpha: 1)
        UIView.animate(withDuration: 0.2) {
            self.chatButton.transform = CGAffineTransform.identity
        }
    }
    
    @objc private func animateOnTap() {
        UIView.animate(withDuration: 0.4,
                       animations: {
                        self.chatButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        },
                       completion: { _ in
                        UIView.animate(withDuration: 0.3) {
                            self.chatButton.transform = CGAffineTransform.identity
                        }
        })
    }
}
