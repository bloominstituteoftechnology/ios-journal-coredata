//
//  EntryController.swift
//  Journal
//
//  Created by Kenny on 1/27/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import Foundation
import CoreData

enum MoodType: String {
    case sad = "😢"
    case neutral = "😑"
    case happy = "🤣"
    static var allMoods: [MoodType] {
        return [.sad, .neutral, .happy]
    }
}

class EntryController {
    //MARK: Properties
    typealias CompletionHandler = (Error?) -> ()
    let save = {
        CoreDataStack.shared.saveToPersistentStore()
    }
    private let baseURL = URL(string:"https://lambda-journal-f748d.firebaseio.com/")!
    let context = CoreDataStack.shared.mainContext
    
    //MARK: Create
    func createEntry(title: String, bodyText: String, mood: MoodType) {
        let entry = Entry(title: title, bodyText: bodyText, timestamp: Date(), identifier: UUID(), mood: mood.rawValue)
        put(entry: entry) { (_) in
            self.save()
        }
        
    }
    
    func put(entry: Entry, complete: @escaping CompletionHandler) {
        let entryURL = baseURL.appendingPathComponent(entry.identifier?.uuidString ?? "")
        let postURL = entryURL.appendingPathExtension("json")
        guard let request = NetworkService.createRequest(url: postURL, method: .post, headerType: .contentType, headerValue: .json) else {
            complete(NSError(domain: "PutRequestError", code: 400, userInfo: nil))
            return
        }
        guard var rep = entry.entryRepresentation,
            let id = entry.identifier else {
            complete(NSError(domain: "EntryRepresentationConversion", code: 1))
            return
        }
        
        rep.identifier = id.uuidString
        let encodingStatus = NetworkService.encode(from: rep, request: request)
        
        if let error = encodingStatus.error {
            print("error encoding: \(error)")
            complete(error)
            return
        } else {
            URLSession.shared.dataTask(with: encodingStatus.request!) { (data, response, error) in
                if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                    print("Bad response code")
                    complete(NSError(domain: "APIStatusNotOK", code: response.statusCode, userInfo: nil))
                    return
                }
                if let error = error {
                    complete(error)
                    return
                }
                 print("JSON String: \(String(data: data!, encoding: .utf8))")
                complete(nil)
            }.resume()
        }
    }
        
    //MARK: Update
    func updateEntry(newTitle: String, newBodyText: String, entry: Entry, mood: MoodType) {
        entry.title = newTitle
        entry.bodyText = newBodyText
        entry.timestamp = Date()
        entry.mood = mood.rawValue
        save()
    }
    
    //MARK: Delete
    func deleteEntry(entry: Entry) {
        context.delete(entry)
        save()
    }
    
}
