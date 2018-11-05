//
//  Route.swift
//  improve-talking
//
//  Created by Erik Perez on 10/7/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import Foundation

enum Route {
    case login(username: String, password: String)
    case signUp(username: String, password: String)
    
    var path: String {
        switch self {
        case .login: return "/session"
        case .signUp: return "/users"
        }
    }
    
    var httpMethod: String {
        switch self {
        case .login:
            return HTTPMethod.get.rawValue
        case .signUp:
            return HTTPMethod.post.rawValue
        }
    }
    
    var header: [String: String] {
        switch self {
        case .login, .signUp:
            return ["Content-Type": "application/json"]
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case let .login(username, password):
            return ["username": username, "password": password]
        default: return [:]
        }
    }
    
    var body: Data? {
        switch self {
        case let .signUp(username, password):
            let body = [ "username": username, "password": password]
            return try? JSONSerialization.data(withJSONObject: body, options: [])
        default: return nil
        }
    }
    
    // MARK: - Private
    
    private enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case delete = "DELETE"
        case put = "PUT"
        case patch = "PATCH"
    }
}
