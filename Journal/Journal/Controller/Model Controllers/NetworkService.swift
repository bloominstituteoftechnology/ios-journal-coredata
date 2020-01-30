//
//  NetworkService.swift
//  Journal
//
//  Created by Kenny on 1/29/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import Foundation

class NetworkService {
    
    enum HttpMethod: String {
        case get = "GET"
        case post = "POST"
        case delete = "DELETE"
    }

    enum HttpHeaderType: String {
        case contentType = "Content-Type"
    }

    enum HttpHeaderValue: String {
        case json = "application/json"
    }
    
    struct EncodingStatus {
        let request: URLRequest?
        let error: Error?
    }
    
    /**
     Create a request given a URL and requestMethod (get, post, create, etc...)
     */
    class func createRequest(url: URL?, method: HttpMethod, headerType: HttpHeaderType, headerValue: HttpHeaderValue) -> URLRequest? {
        guard let requestUrl = url else {
            NSLog("request URL is nil")
            return nil
        }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = method.rawValue
        request.setValue(headerValue.rawValue, forHTTPHeaderField: headerType.rawValue)
        return request
    }
    
    class func encode(from type: Any?, request: URLRequest) -> EncodingStatus {
        var localRequest = request
        let jsonEncoder = JSONEncoder()
        jsonEncoder.dateEncodingStrategy = .iso8601
        do {
            switch type {
            case is EntryRepresentation:
                localRequest.httpBody = try jsonEncoder.encode(type as? EntryRepresentation)
            default: fatalError("\(String(describing: type)) is not defined locally in encode function")
            }
        } catch {
            print("Error encoding object into JSON \(error)")
            return EncodingStatus(request: nil, error: error)
        }
        return EncodingStatus(request: localRequest, error: nil)
    }
}
