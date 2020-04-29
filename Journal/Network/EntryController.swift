//
//  EntryController.swift
//  Journal
//
//  Created by Chad Parker on 4/28/20.
//  Copyright © 2020 Chad Parker. All rights reserved.
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

class EntryController {
    
    typealias CompletionHandler = (Result<Bool, NetworkError>) -> Void
    
    let baseURL = URL(string: "https://lambda-journal-ec0b2.firebaseio.com/")!
    
    func sendEntryToServer(_ entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        guard let identifier = entry.identifier else {
            completion(.failure(.noIdentifier))
            return
        }
        let url = baseURL.appendingPathComponent(identifier).appendingPathExtension("json")
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        
        do {
            guard let entryRepresentation = entry.entryRepresentation else {
                completion(.failure(.noRep))
                return
            }
            request.httpBody = try JSONEncoder().encode(entryRepresentation)
        } catch {
            NSLog("Error encoding entry \(entry): \(error)")
            completion(.failure(.noEncode))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard error == nil else {
                NSLog("Error PUTing entry to server: \(error!)")
                DispatchQueue.main.async {
                    completion(.failure(.otherError))
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(true))
            }
        }.resume()
    }
    
    func deleteEntryFromServer(_ entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        guard let identifier = entry.identifier else {
            completion(.failure(.noIdentifier))
            return
        }
        let url = baseURL.appendingPathComponent(identifier).appendingPathExtension("json")
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard error == nil else {
                NSLog("Error DELETEing entry on server: \(error!)")
                DispatchQueue.main.async {
                    completion(.failure(.otherError))
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(true))
            }
        }.resume()
    }
}
