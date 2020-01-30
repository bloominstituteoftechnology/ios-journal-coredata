//
//  NetworkService.swift
//  Journal
//
//  Created by Kenny on 1/29/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import Foundation

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


class NetworkService {
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
}
