//
//  ToastAPI.swift
//  improve-talking
//
//  Created by Erik Perez on 10/7/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import Foundation

class ToastAPI {
    
    typealias CompletionHandler = ([String: Any]?, Error?, Int?) -> Void
    
    static let webSocketURL = URL(string: "wss://improve-talking.herokuapp.com/cable")!
    static var webSocketOrigin: String {
        return baseAPIURL
    }
    
    static func login(withUsername username: String, password: String, completionHandler handler: @escaping CompletionHandler) {
        
        request(withRoute: .login(username: username, password: password), completionHandler: handler)
    }
    
    static func signUp(withUsername username: String, password: String, completionHandler handler: @escaping CompletionHandler) {
        
        request(withRoute: .signUp(username: username, password: password), completionHandler: handler)
    }
    
    // MARK: - Private
    
    private static let baseAPIURL = "https://improve-talking.herokuapp.com"
    
    private static func request(withRoute route: Route, completionHandler handler: @escaping CompletionHandler) {
        do {
            let url = try buildURL(withBaseStringURL: baseAPIURL, route: route)
            var request = URLRequest(url: url)
            request.httpMethod = route.httpMethod
            request.allHTTPHeaderFields = route.header
            request.httpBody = route.body
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let response = response as? HTTPURLResponse else { return }
                guard error == nil else {
                    handler(nil, error, response.statusCode)
                    return
                }
                guard let data = data,
                    let json = try? JSONSerialization.jsonObject(with: data, options: []),
                    let result = json as? [String: Any] else {
                        handler(nil, ToastAPIError.invalidJSON(path: route.path), response.statusCode)
                        return
                }
                handler(result, nil, response.statusCode)
                return
            }.resume()
        } catch {
            // We catch errors for buildURL(stringURL:route:)
            handler(nil, error, nil)
        }
    }
    
    private static func buildURL(withBaseStringURL stringURL: String, route: Route) throws -> URL {
        guard let url = URL(string: stringURL)?.appendingPathComponent(route.path),
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
                throw ToastAPIError.invalidURL(path: route.path)
        }
        components.queryItems = try? route.parameters.map { key, value in
            guard let validValue = value as? CustomStringConvertible else {
                throw ToastAPIError.invalidParameter(key: key, Value: value)
            }
            return URLQueryItem(name: key, value: validValue.description)
        }
        guard let finalURL = components.url else {
            throw ToastAPIError.invalidURL(path: route.path)
        }
        return finalURL
    }
    
    private enum ToastAPIError: Error {
        case invalidURL(path: String)
        case invalidJSON(path: String)
        case invalidParameter(key: String, Value: Any)
    }
}
