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
		
		URLSession.shared.dataTask(with: request) { (_ , _, error) in
			if let error = error {
				NSLog("Error puting entryRep to firebase: \(error)")
				completion(nil)
			}
			entry.identifier = identifier
			
//			try? self.save
			
			completion(nil)
		}.resume()
		
	}
	
	
	private let baseUrl: URL = URL(string: "https://hectorsvill-journal.firebaseio.com/")!
}
