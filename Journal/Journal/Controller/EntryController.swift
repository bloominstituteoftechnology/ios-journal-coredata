//
//  EntryController.swift
//  Journal
//
//  Created by Claudia Contreras on 4/28/20.
//  Copyright © 2020 thecoderpilot. All rights reserved.
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
    
    typealias CompletionHandler = (Result<Bool, NetworkError>) -> Void
    
    // MARK: - Properties
    let baseURL = URL(string: "https://journal-23243.firebaseio.com/")!
    
    // MARK: - Functions
    func sendEntryToServer(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        guard let identifier = entry.identifier else {
            completion(.failure(.noIdentifier))
            return
        }
        //Take the baseURL and append the identifier of the entry parameter to it. Add the "json" extension to the URL as well.
        let requestURL = baseURL.appendingPathComponent(identifier).appendingPathExtension("json")
        
        //Create a URLRequest object. Set its HTTP method to PUT.
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        //Using JSONEncoder, encode the entry's entryRepresentation into JSON data. Set the URL request's httpBody to this data.
        do {
            guard let entryRepresentation = entry.entryRepresentation else {
                completion(.failure(.noRep))
                return
            }
            
            request.httpBody = try JSONEncoder().encode(entryRepresentation)
        } catch {
            NSLog("Error encoding task \(entry): \(error)")
            completion(.failure(.noEncode))
        }
        
        //Perform a URLSessionDataTask with the request, and handle any errors. Make sure to call completion and resume the data task.
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error Puting task to server: \(error)")
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
    
    func deleteEntryFromServer(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        guard let identifier = entry.identifier else {
            completion(.failure(.noIdentifier ))
            return
        }
        
        // Create a URL from the baseURL and append the entry parameter's identifier to it. Also append the "json" extension to the URL as well. This URL should be formatted the same as the URL you would use to PUT an entry to Firebase.
        let requestURL = baseURL.appendingPathExtension(identifier).appendingPathExtension("json")
        
        // Create a URLRequest object, and set its HTTP method to DELETE.
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        // Perform a URLSessionDataTask with the request and handle any errors. Call completion and don't forget to resume the data task.
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error deleting task in server: \(error)")
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

