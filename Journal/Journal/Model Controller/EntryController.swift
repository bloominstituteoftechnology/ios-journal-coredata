//
//  EntryController.swift
//  Journal
//
//  Created by Waseem Idelbi on 4/30/20.
//  Copyright © 2020 WaseemID. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    //MARK: - Properties -
    
    typealias CompletionHandler = (Result<Bool, NetworkError>) -> Void
    
    let baseURL = URL(string: "https://journal-211f4.firebaseio.com/")!
    
    //MARK: - Methods -
    
    func sendEntryToServer(entry: Entry, completion: @escaping CompletionHandler) {
        
        guard let id = entry.identifier else {
            completion(.failure(.noIdentifier))
            return
        }
        
        let requestURL = baseURL.appendingPathComponent(id).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            
            guard let entryRep = entry.entryRepresentation else {
                completion(.failure(.noRep))
                return
            }
            
            request.httpBody = try JSONEncoder().encode(entryRep)
        } catch {
            NSLog("Could not encode the entry's representaion: \(error)")
            completion(.failure(.noEncode))
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            
            if let error = error {
                DispatchQueue.main.async {
                    NSLog("Could not send entry to server: \(error)")
                    completion(.failure(.otherError))
                    return
                }
            }
            
            DispatchQueue.main.async {
                completion(.success(true))
            }
            
        }.resume()
        
    }
    
    func deleteEntryFromServer(entry: Entry, completion: CompletionHandler?) {
        
        guard let id = entry.identifier else {
            completion!(.failure(.noIdentifier))
            return
        }
        
        let requestURL = baseURL.appendingPathComponent(id).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            
            if let error = error {
                DispatchQueue.main.async {
                    NSLog("Could not delete entry from server: \(error)")
                    completion!(.failure(.otherError))
                    return
                }
            }
            
            DispatchQueue.main.async {
                completion!(.success(true))
            }
            
        }.resume()
        
    }
    
}
