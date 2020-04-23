//
//  EntryController.swift
//  Journal
//
//  Created by Cameron Collins on 4/23/20.
//  Copyright © 2020 Cameron Collins. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    //MARK: - Variables
    let baseURL = URL(string: "https://journal-e302d.firebaseio.com/")
    
    
    //MARK: - Functions
    func sendTaskToServer(entry: Entry, completion: @escaping () -> Void ) {
        
        //Setting up URLRequest for Sending
        guard let baseURL = baseURL else {
            print("Bad URL")
            completion()
            return
        }
        let requestURL = baseURL.appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        guard let entryRepresentation = entry.entryRepresentation else {
            print("Bad EntryRepresentation")
            print("\(entry.entryRepresentation)")
            completion()
            return
        }
        
        do {
            request.httpBody = try JSONEncoder().encode(entryRepresentation)
        } catch {
            print("Error Encoding: \(error)")
        }
        
        //Sending the URL Request
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error sending entry: \(error)")
                completion()
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("Error Bad Reponse Code")
                completion()
                return
            }
        }.resume()
        
        //Successful
        print("End of function Called")
        completion()
    }
    
    //Deletes entry from the server
    func deleteEntryFromServer(entry: Entry, completion: @escaping () -> Void) {
        guard let baseURL = baseURL else {
            print("Bad URL")
            return
        }
        
        let requestURL = baseURL.appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                NSLog("Error deleting task from server: \(error)")
                completion()
                return
            }
            
            completion()
        }.resume()
    }
}
