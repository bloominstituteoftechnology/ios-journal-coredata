//
//  EntryController.swift
//  Journal
//
//  Created by Hector Steven on 5/29/19.
//  Copyright © 2019 Hector Steven. All rights reserved.
//

import Foundation


class EntryController {
	
	func put(entry: Entry, completion: @escaping (Error?) -> ()) {
		let identifier = entry.identifier ?? UUID().uuidString
		let url = baseUrl.appendingPathComponent(identifier).appendingPathExtension("json")
		
		var request = URLRequest(url: url)
		request.httpMethod = "PUT"
		
		do {
			guard let entryRep = entry.entryRepresentation else {
				completion(NSError())
				return
			}
			
			request.httpBody = try JSONEncoder().encode(entryRep)
			
		} catch {
			NSLog("Error encoding TaskRepresentation")
			completion(error)
			return
		}
		
		URLSession.shared.dataTask(with: request) { (_ , response, error) in
			if let response = response as? HTTPURLResponse{
				print("Respnse Code: \(response.statusCode)")
			}
			
			if let error = error {
				NSLog("Error puting entryRep to firebase: \(error)")
				completion(nil)
			}
			entry.identifier = identifier
		
//			try? self.save
			print(request)
			completion(nil)
		}.resume()
		
	}
	
	func deleteEntryFromServer(entry: Entry, completion: @escaping (Error?) -> ()) {
		let identifier = entry.identifier ?? UUID().uuidString
		let url = baseUrl.appendingPathComponent(identifier).appendingPathExtension("json")
		
		var request = URLRequest(url: url)
		request.httpMethod = "DELETE"
		
		do {
			guard let entryRep = entry.entryRepresentation else {
				completion(NSError())
				return
			}
			
			request.httpBody = try JSONEncoder().encode(entryRep)
			
		} catch {
			NSLog("Error encoding TaskRepresentation")
			completion(error)
			return
		}
		
		URLSession.shared.dataTask(with: request) { (_ , response, error) in
			if let response = response as? HTTPURLResponse{
				print("Respnse Code: \(response.statusCode)")
			}
			
			if let error = error {
				NSLog("Error puting entryRep to firebase: \(error)")
				completion(nil)
			}
			
			entry.identifier = identifier
			
			//try? self.save
			
			completion(nil)
			}.resume()
	}
	
	func fetchEntriesFromServer(completion: @escaping (Error?) -> ()) {
		let url = baseUrl.appendingPathExtension("json")
		URLSession.shared.dataTask(with: url) { (data, response, error) in
			if let response = response as? HTTPURLResponse {
				print("FetchEntries ResponseCode: \(response.statusCode)")
			}
			
			if let error = error {
				print("Error FetchingEntries: \(error)")
				completion(error)
				return
			}
			
			guard let data = data else {
				print("Error FetchingEntries: geting data")
				completion(NSError())
				return
			}
			
			print(data)
			
			completion(nil)
		}.resume()
	}
	
	private let baseUrl: URL = URL(string: "https://journal-hectorsvill.firebaseio.com/")!
}
