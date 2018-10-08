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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Method not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        twilioHandler.delegate = self
        twilioHandler.connectToRoom(withName: roomName, token: token)
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
