//
//  Mood.swift
//  Jurnal CoreData
//
//  Created by Sergey Osipyan on 1/22/19.
//  Copyright © 2019 Sergey Osipyan. All rights reserved.
//

import Foundation


enum MoodFace: String, CaseIterable {
   
    case 😀
    case 😐
    case 😔
}

extension Entry {
    
    var moodFace: MoodFace {
    get {
        return MoodFace(rawValue: mood!) ?? .😐
    }
        set {
            mood = newValue.rawValue
        }
    }
}
