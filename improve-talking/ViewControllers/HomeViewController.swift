//
//  ViewController.swift
//  improve-talking
//
//  Created by Erik Perez on 10/7/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController, ToastSocketHandlerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        buildChatButton()
        buildSocketHandler()
    }
    
    // MARK: ToastSocketHandlerDelegate
    
    func didCreateChatRoom(withName roomName: String, token: String) {
        print("\n* created chat room name: \(roomName), token\(token)\n")
    }
    
    // MARK: - Private
    
    private var socketHandler: ToastSocketHandler?
    
    private func buildChatButton() {
        let button = UIButton()
        button.setTitle("Chat", for: .normal)
        button.backgroundColor = .gray
        button.addTarget(self, action: #selector(chatButtonPressed(_:)), for: .touchUpInside)
        view.addSubview(button)
        button.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview().inset(40)
            maker.bottom.equalToSuperview().inset(100)
        }
    }
    
    @objc private func chatButtonPressed(_ sender: UIButton) {
        
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

