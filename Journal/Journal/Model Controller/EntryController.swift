//
//  EntryController.swift
//  Journal
//
//  Created by Clayton Watkins on 6/10/20.
//  Copyright © 2020 Clayton Watkins. All rights reserved.
//

import Foundation

// To handle network call errors
enum NetworkError: Error{
    case noIdentifier
    case otherError
    case noData
    case noDecode
    case noEncode
    case noRep
}

// The base URL for our database
var baseURL = URL(string: "https://journal-26adb.firebaseio.com/")!

class EntryController {
    
    // MARK: - Properties
    typealias CompletionHandler = (Result<Bool, NetworkError>) -> Void
    
    // MARK: - Network Functions
    
    //This will send our entries to our server
    func sendEntryToServer(entry: Entry, completion: @escaping CompletionHandler = { _ in }){
        guard let uuid = entry.identifier else {
            completion(.failure(.noIdentifier))
            return
        }
        
        let requestURL = baseURL.appendingPathComponent(uuid).appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do{
            guard let representation = entry.entryRepresentation else {
                completion(.failure(.noRep))
                return
            }
            request.httpBody = try JSONEncoder().encode(representation)
        } catch {
            print("Error encoding task \(entry): \(error)")
            completion(.failure(.noEncode))
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error{
                completion(.failure(.otherError))
                print("Error putting task to server: \(error)")
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(true))
            }
        }.resume()
    }
    
    
}
