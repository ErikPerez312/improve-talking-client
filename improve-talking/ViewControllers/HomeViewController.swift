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
        buildOnlineUsersLabel()
//        buildTodayTopic()
        buildChatButton()
        buildSocketHandler()
        
    }
    
    //MARK: OUTLETS
    let button = UIButton()
    
    // MARK: ToastSocketHandlerDelegate
    
    func didCreateChatRoom(withName roomName: String, token: String) {
        let chatViewController = ChatViewController(roomName: roomName, token: token)
        self.present(chatViewController, animated: true, completion: nil)
    }
    
    // MARK: - Private
    
    private var socketHandler: ToastSocketHandler?
    
    
    private func buildOnlineUsersLabel() {
        
        let valueLabel = UILabel()
        valueLabel.text = "25"
        valueLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 25)
        valueLabel.textColor = #colorLiteral(red: 0.231372549, green: 0.2509803922, blue: 0.2784313725, alpha: 1)
        self.view.addSubview(valueLabel)
        valueLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-40)
            make.top.equalToSuperview().offset(45)
        }
        
        let label = UILabel()
        label.text = "Online Users:"
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 25)
        label.textColor = #colorLiteral(red: 0.231372549, green: 0.2509803922, blue: 0.2784313725, alpha: 1)
        self.view.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.right.equalTo(valueLabel.snp.left).offset(-5)
            make.top.equalToSuperview().offset(45)
        }
    }
    
    
    private func buildTodayTopic() {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
        containerView.layer.cornerRadius = 15
        containerView.layer.shadowColor = #colorLiteral(red: 0.231372549, green: 0.2509803922, blue: 0.2784313725, alpha: 1)
        containerView.layer.shadowRadius = 2.0
        containerView.layer.shadowOpacity = 1.0
        containerView.layer.shadowOffset = CGSize(width: 0, height: 1)
        containerView.layer.masksToBounds = false

        view.addSubview(containerView)
        
        containerView.snp.makeConstraints { (make) in
            make.height.equalTo(200)
            make.leading.trailing.equalToSuperview().inset(40)
            make.top.equalToSuperview().offset(220)
        }
        
        let label = UILabel()
        label.text = "Today's Topic"
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 25)
        label.textColor = #colorLiteral(red: 0.231372549, green: 0.2509803922, blue: 0.2784313725, alpha: 1)
        
    }
    
    @objc private func HoldDown(sender:UIButton)
    {
//        button.backgroundColor = #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)
        UIView.animate(withDuration: 0.3,
                       animations: {
                        self.button.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        })
    }
    
    @objc private func holdReleaseInside(sender:UIButton)
    {
        button.backgroundColor = #colorLiteral(red: 1, green: 0.7137254902, blue: 0.03137254902, alpha: 1)
        UIView.animate(withDuration: 0.2) {
            self.button.transform = CGAffineTransform.identity
        }
        AudioServicesPlayAlertSound(1519)
    }
    
    @objc private func holdReleaseOutside(sender:UIButton)
    {
        button.backgroundColor = #colorLiteral(red: 1, green: 0.7137254902, blue: 0.03137254902, alpha: 1)
        UIView.animate(withDuration: 0.2) {
            self.button.transform = CGAffineTransform.identity
        }
    }
    
    
    @objc private func animateOnTap() {
        UIView.animate(withDuration: 0.4,
                       animations: {
                        self.button.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        },
                       completion: { _ in
                        UIView.animate(withDuration: 0.3) {
                            self.button.transform = CGAffineTransform.identity
                        }
        })
    }
    
    private func buildChatButton() {
        button.setImage(#imageLiteral(resourceName: "Phone"), for: .normal)
        button.layer.cornerRadius = 100
        button.backgroundColor = #colorLiteral(red: 1, green: 0.7137254902, blue: 0.03137254902, alpha: 1)
        button.addTarget(self, action: #selector(chatButtonPressed(_:)), for: .touchUpInside)
        button.adjustsImageWhenHighlighted = false
        view.addSubview(button)
    
        button.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.height.width.equalTo(200)
            maker.bottom.equalToSuperview().inset(200)
        }
    }
    
    @objc private func chatButtonPressed(_ sender: UIButton) {
        socketHandler?.chatWithRemoteUser()
    }
    
    private func buildSocketHandler() {
        let usertoken = "" // TODO: Fetch user token from keychain
        let handler = ToastSocketHandler(socketURL: ToastAPI.webSocketURL,
                                         socketOrigin: ToastAPI.webSocketOrigin,
                                         userToken: usertoken)
        handler.delegate = self
        self.socketHandler = handler
    }
}

