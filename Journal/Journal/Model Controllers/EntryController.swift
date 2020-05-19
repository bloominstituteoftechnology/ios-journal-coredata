//
//  EntryController.swift
//  Journal
//
//  Created by Kelson Hartle on 5/19/20.
//  Copyright © 2020 Kelson Hartle. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case noIdentifier
    case otherError
    case noData
    case noDecode
    case noEncode
    case noRep
    
}

let baseURL = URL(string: "https://journal-e990c.firebaseio.com/")

class EntryController {
    
    typealias CompletionHandler = (Result<Bool, NetworkError>) -> Void
    
    func sendTaskToServer(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        
        guard let identifier = entry.identifier else {
            completion(.failure(.noIdentifier))
            return
        }
        let requestURL = baseURL!.appendingPathComponent(identifier).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        
        do {
            guard let representation = entry.entryRepresentation else {
                completion(.failure(.noRep))
                return
            }
            
            request.httpBody = try JSONEncoder().encode(representation)
            
        } catch {
            NSLog("Error encoding task \(entry): \(error)")
            completion(.failure(.noEncode))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                NSLog("Error sending task to server: \(error)")
                completion(.failure(.otherError))
                return
            }
            
            completion(.success(true))
        }.resume()
    }
}
