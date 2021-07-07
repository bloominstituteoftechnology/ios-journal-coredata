//
//  FirebaseClient.swift
//  Journal
//
//  Created by Shawn Gee on 3/26/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import Foundation

class FirebaseClient {
    
    typealias ErrorCompletion = (Error?) -> Void
    typealias ResultCompletion = (Result<EntryRepsByID, Error>) -> Void
    
    private let baseURL = URL(string: "https://journal-shawngee.firebaseio.com/")!
    
    func fetchEntriesFromServer(completion: @escaping ResultCompletion) {
        let requestURL = baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { (data, response, error) in
            if let error = error {
                NSLog("Error fetching entries \(error)")
                completion(.failure(error))
                return
            }
            
            if let response = response as? HTTPURLResponse,
                !(200...299).contains(response.statusCode) {
                NSLog("Invalid Response: \(response)")
                completion(.failure(NSError(domain: "Invalid Response", code: response.statusCode)))
                return
            }
            
            guard let data = data else {
                NSLog("No data returned")
                completion(.failure(NSError(domain: "No data to decode", code: 1)))
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let entryRepresentations = try decoder.decode(EntryRepsByID.self, from: data)
                completion(.success(entryRepresentations))
            } catch {
                NSLog("Couldn't update entries \(error)")
                completion(.failure(error))
            }
        }.resume()
    }
    
    func sendEntryToServer(_ entry: Entry, completion: @escaping ErrorCompletion = { _ in }) {
        let uuid = entry.identifier
        let requestURL = baseURL.appendingPathComponent(uuid).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            request.httpBody = try JSONEncoder().encode(entry.representation)
        } catch {
            NSLog("Error encoding JSON representation of entry: \(error)")
            completion(error)
            return
        }

        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let error = error {
                NSLog("Error PUTing entry to server: \(error)")
                completion(error)
                return
            }
            
            if let response = response as? HTTPURLResponse,
                !(200...299).contains(response.statusCode) {
                NSLog("Invalid Response: \(response)")
                completion(NSError(domain: "Invalid Response", code: response.statusCode))
                return
            }
            
            completion(nil)
        }.resume()
    }
    
    func deleteEntryWithID(_ uuid: String, completion: @escaping ErrorCompletion = { _ in }) {
        let requestURL = baseURL.appendingPathComponent(uuid).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"

        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let error = error {
                NSLog("Error deleting entry from server: \(error)")
                completion(error)
                return
            }
            
            if let response = response as? HTTPURLResponse,
                !(200...299).contains(response.statusCode) {
                NSLog("Invalid Response: \(response)")
                completion(NSError(domain: "Invalid Response", code: response.statusCode))
                return
            }

            completion(nil)
        }.resume()
    }
}


