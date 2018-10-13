//
//  ChatViewController.swift
//  improve-talking
//
//  Created by Erik Perez on 10/8/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import UIKit
import TwilioVideo

class ChatViewController: UIViewController, TwilioHandlerDelegate {
    
    init(roomName: String, token: String) {
        self.roomName = roomName
        self.token = token
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1, green: 0.7137254902, blue: 0.03137254902, alpha: 1)
        addSubviews()
        setConstraints()
        twilioHandler.delegate = self
        twilioHandler.connectToRoom(withName: roomName, token: token)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Method not supported")
    }
    
    // MARK: - Private
    
    private var currentTopicLabel: UILabel = {
        var label = UILabel()
        label.textColor = UIColor.white
        label.text = "Current Topic:"
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 35)
        return label
    }()
    
    private var topicLabel: UILabel = {
        var label = UILabel()
        label.textColor = UIColor.white
        label.text = "Bubble"
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 65)
        return label
    }()
    
    private var iconImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "Audio")
        return imageView
    }()
    
    private var cancelButton: UIButton = {
        var button = UIButton()
        button.setImage(#imageLiteral(resourceName: "Cancel"), for: .normal)
        button.layer.cornerRadius = 100
        button.adjustsImageWhenHighlighted = false
        button.addTarget(self, action: #selector(cancelButtonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    private func addSubviews() {
         [currentTopicLabel, topicLabel, iconImageView, cancelButton].forEach { (subview) in
            view.addSubview(subview)
         }
    }
    
    private func setConstraints() {
        currentTopicLabel.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview().offset(65)
            maker.centerX.equalToSuperview()
        }
        
        topicLabel.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(currentTopicLabel.snp.bottom).offset(30)
        }
        
        iconImageView.snp.makeConstraints { (maker) in
            maker.height.width.equalTo(200)
            maker.top.equalTo(topicLabel.snp.bottom).offset(45)
            maker.centerX.equalToSuperview()
        }
        
        cancelButton.snp.makeConstraints { (maker) in
            maker.width.height.equalTo(105)
            maker.centerX.equalToSuperview()
            maker.top.equalTo(iconImageView.snp.bottom).offset(75)
        }
        
    }
    
    @objc private func cancelButtonPressed(_ sender: UIButton) {
        // TODO: Implement method body
        print("\n*ChatViewController -> cancelButtonPressed(_:): Missing method body")
    }
    
    // MARK: TwilioHandlerDelegate
    
    func addRenderer(forLocalVideoTrack videoTrack: TVIVideoTrack) {
        // TODO: Implement method body
        return
    }
    
    func addRenderer(forRemoteVideoTrack videoTrack: TVIVideoTrack) {
        // TODO: Implement method body
        return
    }
    
    func removeRenderer(forRemoteVideoTrack videoTrack: TVIVideoTrack) {
        // TODO: Implement method body
        return
    }
    
    func errorDidOcurr(withMessage message: String, error: Error?) {
        // TODO: Implement method body
        return
    }
    
    func remoteParticipantDidDisconnect() {
        // TODO: Implement method body
        return
    }
    
    // MARK: - Private
    
    private let twilioHandler = TwilioHandler()
    
    private let roomName: String
    private let token: String
}
