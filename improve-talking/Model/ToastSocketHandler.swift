//
//  ToastSocketHandler.swift
//  improve-talking
//
//  Created by Erik Perez on 10/8/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import Foundation
import ActionCableClient

protocol ToastSocketHandlerDelegate: class {
    /// Called when a Twilio chatroom has been created.
    /// - Parameters:
    ///   - roomName: Unique name for the chatroom.
    ///   - token: Secure token for the chatroom.
    func didCreateChatRoom(withName roomName: String, token: String)
}

class ToastSocketHandler {
    
    weak var delegate: ToastSocketHandlerDelegate?
    
    init(socketURL: URL, socketOrigin: String, userToken: String) {
        self.socketURL = socketURL
        self.socketOrigin = socketOrigin
        self.userToken = userToken
        
        buildClient(withSocketURL: socketURL, origin: socketOrigin)
    }
    
    /// Call this method when the user wants to enter a chatroom.
    func chatWithRemoteUser() {
        guard let _ = delegate else {
            fatalError("\n ToastSocketHandler: Missing delegate\n")
        }
        chatChannel?.action("connect")
    }
    
    // MARK: - Private
    
    private let userToken: String
    private let socketURL: URL
    private let socketOrigin: String
    
    private var chatChannel: Channel?
    
    private func buildClient(withSocketURL socketURL: URL, origin: String) {
        let client = ActionCableClient(url: socketURL)
        client.origin = origin
        client.headers = ["Authorization": userToken]
        client.connect()
        
        client.onConnected = {
            self.buildChatChannel(withClient: client)
            print("\n* ToastSocketHandler: Connected to client")
        }
        client.onDisconnected = { (error: ConnectionError?) in
            print("\n* ToastSocketHandler: Disconnected from client with error: \(String(describing: error))\n")
        }
    }
    
    private func buildChatChannel(withClient client: ActionCableClient) {
        let channel = client.create("ChatChannel")
        self.chatChannel = channel
        channel.onReceive = { (data: Any?, error: Error?) in
            guard let data = data,
                let chatRoom = data as? [String: String],
                let roomName = chatRoom["room_name"],
                let token = chatRoom["twilio_token"] else {
                    print("\n* ToastSocketHandler: Failed to decode Twilio Response")
                    return
            }
            print("\n* ToastSocketHandler: recieved Twilio name: \(roomName)\nToken: \(token)")
            self.delegate?.didCreateChatRoom(withName: roomName, token: token)
        }
        channel.onSubscribed = {
            print("\n* ToastSocketHandler: Did subscribe to ChatChannel\n")
        }
        
        channel.onUnsubscribed = {
            print("\n* ToastSocketHandler: Did unsubscribe to ChatChannel\n")
        }
    }
}
