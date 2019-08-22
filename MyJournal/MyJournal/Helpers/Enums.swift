//
//  Enums.swift
//  MyJournal
//
//  Created by Jeffrey Santana on 8/20/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import Foundation

enum MoodEmoji: String, CaseIterable {
	case 😞, 😐, 🙂, 😃
	
	static var defaultIndex: Int {
		return self.allCases.count / 2
	}
}

enum NetworkError: Error {
	case badURL
	case noToken
	case noData
	case notDecoding
	case notEncoding
	case other(Error)
}

enum HTTPMethod: String {
	case get = "GET"
	case put = "PUT"
	case post = "POST"
	case delete = "DELETE"
}
