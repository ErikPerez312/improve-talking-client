//
//  User.swift
//  improve-talking
//
//  Created by Erik Perez on 10/11/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import Foundation

class User {
    let username: String
    let id: Int
    let token: String
    
    var dictionary: NSDictionary {
        return ["username": username,
                "id": id,
                "token": "** Token stored in Keychain **"
        ]
    }
    
    init?(json: [String: Any]) {
        guard let username = json["username"] as? String,
            let id = json["id"] as? Int,
            let token = json["token"] as? String else {
                return nil
        }
        self.username = username
        self.id = id
        self.token = token
    }
}
