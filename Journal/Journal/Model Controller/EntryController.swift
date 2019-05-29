//
//  EntryController.swift
//  Journal
//
//  Created by Christopher Aronson on 5/27/19.
//  Copyright © 2019 Christopher Aronson. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String {
    case 😭
    case 😐
    case 😊
}

enum HTTPMethod: String {
    case PUT
    case GET
    case POST
    case DELETE
}

class EntryController {
    //MARK: - Properties
    let baseURL = URL(string: "https://journal-e4be9.firebaseio.com/")!

    // MARK: - CRUD Methods
    func saveToPersistentStore() {

        do{
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Could Not save data to persistent Stores: \(error)")
        }
    }

    func createEntry(title: String, bodyText: String, mood: String) {

        let entry = Entry(title: title, bodyText: bodyText, mood: mood)

        saveToPersistentStore()

        put(entry: entry) {

        }
    }

    func update(entry: Entry, title: String, bodyText: String, mood: String) {

        entry.title = title
        entry.bodyText = bodyText
        entry.mood = mood
        entry.timestamp = Date()

        saveToPersistentStore()
        put(entry: entry) {

        }
    }

    func delete(entry: Entry) {

        let moc = CoreDataStack.shared.mainContext

        moc.delete(entry)
        saveToPersistentStore()
        delete(entry: entry) { _ in

        }
    }

    //MARK: - HTTP Methods
    func put(entry: Entry, completion: @escaping () -> Void) {

        let requestURL = baseURL
            .appendingPathComponent(entry.identifier ?? UUID().uuidString)
            .appendingPathExtension("json")

        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.PUT.rawValue

        do{
            try request.httpBody = JSONEncoder().encode(entry)
        } catch {
            NSLog("Could not encode entry to json: \(error)")
        }

        URLSession.shared.dataTask(with: request) { (_, _, error) in

            if let error = error {
                NSLog("Could not PUT data: \(error)")
                completion()
                return
            }

            completion()
        }.resume()
    }

    func delete(entry: Entry, completion: @escaping (Error?) -> Void) {

        let requestURL = baseURL
            .appendingPathComponent(entry.identifier ?? UUID().uuidString)
            .appendingPathExtension("json")

        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.DELETE.rawValue

        URLSession.shared.dataTask(with: request) { (_, _, error) in

            if let error = error {
                NSLog("Could not get connect to database to delete: \(error)")
                completion(error)
                return
            }

            completion(nil)
        }.resume()
    }

}
