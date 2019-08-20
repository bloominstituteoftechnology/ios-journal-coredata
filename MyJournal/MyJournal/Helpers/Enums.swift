//
//  Enums.swift
//  MyJournal
//
//  Created by Jeffrey Santana on 8/20/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import Foundation

enum EntryEmoji: String, CaseIterable {
	case 😞, 😐, 🙂, 😃
	
	static var defaultIndex: Int {
		return self.allCases.count / 2
	}
}
