//
//  EntryController.swift
//  Journal
//
//  Created by Harmony Radley on 4/22/20.
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

let baseURL = URL(string: "https://journal-b461d.firebaseio.com/")!

class EntryController {
    
    typealias CompletionHandler = (Result<Bool, NetworkError>) -> Void
    
    
    func sendTaskToServer(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
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
        
        func deleteEntryFromServer(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
               guard let uuid = entry.identifier else {
                   completion(.failure(.noIdentifier))
                   return
               }
               let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
               var request = URLRequest(url: requestURL)
               request.httpMethod = "DELETE"
               URLSession.shared.dataTask(with: request) { data, response, error in
                   if let error = error {
                       NSLog("Error deleting entry from server: \(error)")
                       completion(.failure(.otherError))
                       return
                   }
                   completion(.success(true))
               }.resume()
           }
    }
    
    
    
    
    
    
    
    
    
}
