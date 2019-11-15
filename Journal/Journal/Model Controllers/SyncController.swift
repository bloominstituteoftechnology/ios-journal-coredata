//
//  SyncController.swift
//  Journal
//
//  Created by Jon Bash on 2019-11-14.
//  Copyright © 2019 Jon Bash. All rights reserved.
//

import Foundation

typealias CompletionHandler = (Error?) -> Void

class SyncController {
    // MARK: - URLRequest Generators
    
    private let baseURL: URL = URL(string: "https://lambda-ios-journal-bc168.firebaseio.com/")!
    
    private func urlRequest(for id: String?) -> URLRequest {
        if let id = id {
            return URLRequest(url:
                baseURL.appendingPathComponent(id)
                .appendingPathExtension(.json)
            )
        }
        return URLRequest(url: baseURL.appendingPathExtension(.json))
    }
    
    private func urlRequest() -> URLRequest {
        return urlRequest(for: nil)
    }
    
    // MARK: - Fetch
    
    // TODO: implement `Result` type in closure
    func fetchEntriesFromServer(completion: @escaping (Error?, [Entry.Representation]?) -> Void = { _,_ in }) {
        let request = urlRequest()
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("Error fetching entries: \(error)")
                completion(error, nil)
                return
            }
            guard let data = data else {
                print("No data returned by data task!")
                completion(nil, nil)
                return
            }
            
            do {
                let entryRepresentations = Array(try JSONDecoder().decode(
                    [String : Entry.Representation].self,
                    from: data
                ).values)
                completion(nil, entryRepresentations) // update local entries from server
            } catch {
                print("Error decoding entry representations: \(error)")
                completion(error, nil)
                return
            }
        }.resume()
    }
    
    // MARK: - Send
    
    func sendToServer(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        var request = urlRequest(for: entry.identifier!) // bad IDs just handled
        request.httpMethod = HTTPMethod.put
        
        do {
            guard let representation = entry.representation else {
                print("Error: failed to get entry representation.")
                completion(nil)
                return
            }
            request.httpBody = try JSONEncoder().encode(representation)
        } catch {
            print("Error encoding entry: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error PUTing task to server: \(error)")
            }
            completion(error)
        }.resume()
    }
    
    // MARK: - Delete
    
    func deleteEntryFromServer(_ entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        guard let id = entry.identifier else {
            print("Error: entry has no identifier!")
            completion(nil)
            return
        }
        var request = urlRequest(for: id)
        request.httpMethod = HTTPMethod.delete
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error deleting task from server: \(error)")
            }
            completion(error)
        }.resume()
    }
}
