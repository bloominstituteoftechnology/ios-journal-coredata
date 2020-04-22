//
//  EntryController.swift
//  Journal
//
//  Created by Hunter Oppel on 4/22/20.
//  Copyright © 2020 LambdaSchool. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case noRep
    case noIdentifier
    case otherError
}

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case delete = "DELETE"
}

let baseURL: URL = URL(string: "https://journal-c85b9.firebaseio.com/")!

class EntryController {
    
    typealias CompletionHandler = (Result<Bool, NetworkError>) -> Void
    
    func sendEntryToServer(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        guard let uuid = entry.identifier else {
            NSLog("Entry \(entry) had no identifier.")
            return completion(.failure(.noIdentifier))
        }
        
        var request = apiRequest(uuid: uuid, method: .put)
        do {
            guard let representation = entry.entryRepresentation else {
                NSLog("Unable to get rep from entry \(entry)")
                return completion(.failure(.noRep))
            }
            request.httpBody = try JSONEncoder().encode(representation)
        } catch {
            NSLog("Failed to encode entry \(entry): \(error)")
            return completion(.failure(.otherError))
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                NSLog("Session returned with error: \(error)")
                return completion(.failure(.otherError))
            }
            
            completion(.success(true))
        }
        .resume()
    }
    
    func deleteEntryFromServer(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        guard let uuid = entry.identifier else {
            NSLog("Entry \(entry) had no identifier.")
            return completion(.failure(.noIdentifier))
        }
        
        let request = apiRequest(uuid: uuid, method: .delete)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                NSLog("Session return with error: \(error)")
                return completion(.failure(.otherError))
            }
            
            completion(.success(true))
        }
        .resume()
    }
    
    // MARK: - Helper Methods
    
    private func apiRequest(uuid: UUID, method: HTTPMethod) -> URLRequest {
        let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = method.rawValue
        return request
    }
}
