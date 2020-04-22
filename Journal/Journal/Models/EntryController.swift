//
//  EntryController.swift
//  Journal
//
//  Created by Mark Poggi on 4/22/20.
//  Copyright © 2020 Mark Poggi. All rights reserved.
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

let baseURL = URL(string: "https://journal-5b606.firebaseio.com/")!

class EntryController {
    
    typealias CompletionHandler = (Result<Bool, NetworkError>) -> Void
    
    func sendEntryToServer(entry: Entry, completion: @escaping CompletionHandler = { _ in}) {
        guard let uuid = entry.identifier else {
            completion(.failure(.noIdentifier))
            return
        }
        
        let requestURL = baseURL.appendingPathComponent(uuid).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"  // POST creates a new record on the server EVEN if it already exists - always ADDs.  PUT says create if not there, overwrite/replace if it exists.
        
        do {
            guard let representation = entry.entryRepresentation else {
                completion(.failure(.noRep))
                return
            }
            request.httpBody  = try JSONEncoder().encode(representation)
        } catch {
            NSLog("error encoding entry \(entry): \(error)")
            completion(.failure(.noEncode))
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("error sending entry to server: \(error)")
                completion(.failure(.otherError))
                return
            }
            
            //            if let response = response as? HTTPURLResponse,
            //                response.statusCode != 200 {
            //
            //            }
            
            completion(.success(true))
        }.resume()
    }
    
    func deleteEntryFromServer(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        guard let uuid = entry.identifier else {
            completion(.failure(.noIdentifier))
            return
        }
        
        let requestURL = baseURL.appendingPathComponent(uuid).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                NSLog("error deleting entry from server: \(error)")
                completion(.failure(.otherError))
                return
                
            }
            
            completion(.success(true))
        }.resume()
    }
}
