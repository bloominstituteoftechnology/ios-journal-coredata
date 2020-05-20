//
//  EntryController.swift
//  Journal
//
//  Created by Harmony Radley on 5/20/20.
//  Copyright © 2020 Harmony Radley. All rights reserved.
//

import Foundation
import CoreData

enum NetworkError: Error {
    case noIdentifier
    case otherError
    case noData
    case noDecode
    case noEncode
    case noRep
}


class EntryController {
    let baseURL = URL(string: "https://journal---day-3.firebaseio.com/")
    
    typealias CompletionHandler = (Result<Bool, NetworkError>) -> Void
    
    
    func sendTaskToServer(entry: Entry, completion: @escaping CompletionHandler =
    { _ in }) {
    guard let uuid = entry.identifier else {
        completion(.failure(.noIdentifier))
        return
    }
        
    let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
        
    var request = URLRequest(url: requestURL)
    request.httpMethod = "PUT"
    
    do {
        guard let representation = entry.entryRepresentation else {
            completion(.failure(.noRep))
            return
        }
        request.httpBody = try JSONEncoder().encode(representation)
    } catch {
        NSLog("Error encoding entry \(entry): \(error)")
        completion(.failure(.noEncode))
        return
    }
    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            NSLog("Error sending entry to server: \(error)")
            completion(.failure(.otherError))
            return
        }
        completion(.success(true))
    }.resume()
}
}
