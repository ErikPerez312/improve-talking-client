//
//  TwilioHandler.swift
//  improve-talking
//
//  Created by Erik Perez on 10/8/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import Foundation
import TwilioVideo

protocol TwilioHandlerDelegate: class {
    /// Called when the local user's video feed is ready to be shared.
    /// - Parameters:
    ///   - videoTrack: The video feed.
    func addRenderer(forLocalVideoTrack videoTrack: TVIVideoTrack)
    /// Called when the local user's chatroom partner has started sharing their video feed.
    /// - Parameters:
    ///   - videoTrack: The video feed being shared with local user.
    func addRenderer(forRemoteVideoTrack videoTrack: TVIVideoTrack)
    /// Called when the local user's chatroom partner has stopped sharing their video feed.
    /// - Parameters:
    ///   - videoTrack: The video feed that has been removed.
    func removeRenderer(forRemoteVideoTrack videoTrack: TVIVideoTrack)
    
    func errorDidOcurr(withMessage message: String, error: Error?)
    func remoteParticipantDidDisconnect()
}

class TwilioHandler: NSObject {
    
    weak var delegate: TwilioHandlerDelegate?
    
    /// Connects user to Twilio chatroom.
    /// - Parameters:
    ///   - name: The unique name for the chatroom.
    ///   - token: The secure token for entering the chatroom.
    func connectToRoom(withName name: String, token: String) {
        // We only want to connect to chatroom once we have a delegate.
        guard let _ = delegate else {
            fatalError("\n* TwilioHandler: delegate missing\n")
        }
        let localMedia = prepareLocalMedia()
        let connectOptions = TVIConnectOptions(token: token) { builder in
            builder.audioTracks = localMedia.audioTracks
            builder.videoTracks = localMedia.videoTracks
            builder.roomName = name
        }
        self.room = TwilioVideo.connect(with: connectOptions, delegate: self)
    }
    
    /// Disconnects user from chatroom
    func disconnectFromRoom() {
        cleanUpRemoteParticipant()
        room?.disconnect()
    }
    
    // MARK: - Private
    
    private var room: TVIRoom?
    private var remoteUser: TVIParticipant?
    
    private func prepareLocalMedia() -> (videoTracks: [TVILocalVideoTrack], audioTracks: [TVILocalAudioTrack]){
        guard let audioTrack = TVILocalAudioTrack(options: nil, enabled: true) else {
            return ([TVILocalVideoTrack](), [TVILocalAudioTrack]())
        }
        return ([TVILocalVideoTrack](), [audioTrack])
        
        // TODO: replace method body with commented code when video feature is implemented.
        
        // let camera = TVICameraCapturer(source: .frontCamera, delegate: self)!
        // guard let videoTrack = TVILocalVideoTrack(capturer: camera, enabled: true, constraints: nil),
        //    let audioTrack = TVILocalAudioTrack(options: nil, enabled: true) else {
        //        return ([TVILocalVideoTrack](), [TVILocalAudioTrack]())
        //}
        //delegate?.addRenderer(forLocalVideoTrack: videoTrack)
        //return ([videoTrack], [audioTrack])
    }
    
    private func cleanUpRemoteParticipant() {
        guard let remoteUser = remoteUser else { return }
        if let videoTrack = remoteUser.videoTracks.first {
            delegate?.removeRenderer(forRemoteVideoTrack: videoTrack)
        }
        self.remoteUser = nil
    }
    
}

// MARK: TVIParticipantDelegate

extension TwilioHandler: TVIParticipantDelegate {
    
    func participant(_ participant: TVIParticipant, addedVideoTrack videoTrack: TVIVideoTrack) {
        guard remoteUser == participant else {
            return
        }
        delegate?.addRenderer(forRemoteVideoTrack: videoTrack)
    }
    
    func participant(_ participant: TVIParticipant, removedVideoTrack videoTrack: TVIVideoTrack) {
        guard remoteUser == participant  else {
            return
        }
        delegate?.removeRenderer(forRemoteVideoTrack: videoTrack)
    }
}

// MARK: TVIRoomDelegate

extension TwilioHandler: TVIRoomDelegate {
    
    func didConnect(to room: TVIRoom) {
        // user joined participants room
        guard room.participants.count > 0 else { return }
        remoteUser = room.participants[0]
        remoteUser?.delegate = self
    }
    
    func room(_ room: TVIRoom, didFailToConnectWithError error: Error) {
        delegate?.errorDidOcurr(withMessage: "Failed to connect to room", error: error)
        self.room = nil
    }
    
    func room(_ room: TVIRoom, didDisconnectWithError error: Error?) {
        cleanUpRemoteParticipant()
        delegate?.errorDidOcurr(withMessage: "Disconnected from room", error: error)
        self.room = nil
    }
    
    func room(_ room: TVIRoom, participantDidConnect participant: TVIParticipant) {
        guard remoteUser == nil else { return }
        remoteUser = participant
        remoteUser?.delegate = self
    }
    
    func room(_ room: TVIRoom, participantDidDisconnect participant: TVIParticipant) {
        guard remoteUser == participant else { return }
        cleanUpRemoteParticipant()
        delegate?.remoteParticipantDidDisconnect()
    }
}

// MARK: TVICameraCapturerDelegate

extension TwilioHandler: TVICameraCapturerDelegate {
    
    func cameraCapturer(_ capturer: TVICameraCapturer, didStartWith source: TVICameraCaptureSource) {
        // Can customize camera here
    }
}
