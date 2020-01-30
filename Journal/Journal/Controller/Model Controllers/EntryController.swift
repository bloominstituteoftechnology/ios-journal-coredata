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
    
    //MARK: Init
    init() {
        fetchEntriesFromServer()
    }
    
    //MARK: Create
    func createEntry(title: String, bodyText: String, mood: MoodType) {
        let entry = Entry(title: title, bodyText: bodyText, timestamp: Date(), identifier: UUID(), mood: mood.rawValue)
        put(entry: entry) { (_) in
            
        }
        self.save()
    }
    
    func put(entry: Entry, complete: @escaping CompletionHandler) {
        let postURL = baseURL.appendingPathComponent(entry.identifier?.uuidString ?? UUID().uuidString).appendingPathExtension("json")
        guard let request = NetworkService.createRequest(url: postURL, method: .put, headerType: .contentType, headerValue: .json) else {
            complete(NSError(domain: "PutRequestError", code: 400, userInfo: nil))
            return
        }
        //construct representation of Entry for firebase server
        guard var rep = entry.entryRepresentation,
            let id = entry.identifier else {
            complete(NSError(domain: "EntryRepresentationConversion", code: 1))
            return
        }
        rep.identifier = id.uuidString
        
        //encode
        let encodingStatus = NetworkService.encode(from: rep, request: request)
        if let error = encodingStatus.error {
            print("error encoding: \(error)")
            complete(error)
            return
        } else {
            guard let encodingRequest = encodingStatus.request else {return}
            URLSession.shared.dataTask(with: encodingRequest) { (data, response, error) in
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
                complete(nil)
            }.resume()
        }
    }
    
    //MARK: Read
    func fetchEntriesFromServer(complete: @escaping CompletionHandler = {_ in}) {
        let url = baseURL.appendingPathExtension("json")
        guard let request = NetworkService.createRequest(url: url, method: .get, headerType: .contentType, headerValue: .json) else {
            complete(NSError(domain: "bad request", code: 400, userInfo: nil))
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error)
                complete(error)
                return
            }
            guard let data = data else {
                let error = NSError(domain: "EntryController.fetchEntriesFromServer.request.httpBody.NODATA", code: 0, userInfo: nil)
                print(error)
                complete(error)
                return
            }
            guard let optionalEntryReps = NetworkService.decode(to: [String: EntryRepresentation].self, data: data) else {
                let error = NSError(domain: "EntryController.fetchEntriesFromServer.DECODE_ERROR", code: 0, userInfo: nil)
                print(error)
                complete(error)
                return
            }
            var entryReps = [EntryRepresentation]()
            for (_, representation) in optionalEntryReps {
                entryReps.append(representation)
            }
            self.updateEntries(with: entryReps)
            complete(nil)
        }.resume()
        
    }
        
    //MARK: Update
    func updateEntry(entry: Entry, entryRep: EntryRepresentation) {
        entry.title = entryRep.title
        entry.bodyText = entryRep.bodyText
        #warning("shouldnt this be Date()")
        entry.timestamp = entryRep.timestamp
        entry.mood = entryRep.mood
    }
    
    func updateEntries(with representations: [EntryRepresentation]) {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let identifiers = representations.compactMap { UUID(uuidString: $0.identifier) }
        
        var repDict = Dictionary(uniqueKeysWithValues: zip(identifiers, representations))
        fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiers)
        let context = CoreDataStack.shared.mainContext
        do {
            let entries = try context.fetch(fetchRequest)
            for entry in entries {
                guard let id = entry.identifier,
                    let representation = repDict[id]
                else {continue}
                self.updateEntry(entry: entry, entryRep: representation)
                repDict.removeValue(forKey: id)
                save()
            }
            for rep in repDict.values {
                Entry(entryRepresentation: rep)
                save()
            }
        } catch {
            print(error)
        }
        
    }
    
    //MARK: Delete
    func deleteEntryFromServer(entry: Entry, complete: @escaping CompletionHandler = { _ in }) {
        let url = baseURL.appendingPathComponent(entry.identifier!.uuidString).appendingPathExtension("json")
        guard let request = NetworkService.createRequest(url: url, method: .delete) else {
            complete(NSError(domain: "badRequest", code: 400, userInfo: nil))
            return
        }
        URLSession.shared.dataTask(with: request) { _,response,error in
            if let error = error {
                print("error deleting entry: \(error)")
                complete(error)
                return
            }
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                   print("Bad response code")
                   complete(NSError(domain: "APIStatusNotOK", code: response.statusCode, userInfo: nil))
                   return
            } else {
                complete(nil)
            }
        }.resume()
    }
    
    func deleteEntry(entry: Entry) {
        deleteEntryFromServer(entry: entry)
        context.delete(entry)
        save()
    }
    
}
