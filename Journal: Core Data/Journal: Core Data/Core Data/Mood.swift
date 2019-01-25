//
//  Mood.swift
//  Journal: Core Data
//
//  Created by Ivan Caldwell on 1/22/19.
//  Copyright © 2019 Ivan Caldwell. All rights reserved.
//

import Foundation

enum MoodEmoji: String, CaseIterable {
    case 🙂
    case 😐
    case 🤨} // This is super weired. I have the put the bracket here
// Otherwise xCode will keep screaming at me...
// Or xCode doesn't like sad face... ☹️

extension Entry {
    var moodEmoji: MoodEmoji {
        get {
            return MoodEmoji(rawValue: mood!) ?? .😐
        } set {
            mood = newValue.rawValue
        }
    }
}
