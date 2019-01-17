//
//  EntryMood+Entry+Extension.swift
//  CoreDataJournal
//
//  Created by Benjamin Hakes on 1/15/19.
//  Copyright © 2019 Benjamin Hakes. All rights reserved.
//

import Foundation

enum EntryMood: String, CaseIterable, Codable {
    case 😁
    case 😐
    case 😫
}

extension Entry {
    
    var entryMood: EntryMood {
        
        get {
            return EntryMood(rawValue: mood!) ?? .😐
        }
        
        set {
            mood = newValue.rawValue
        }
    }
}
