//
//  Mood.swift
//  Journal
//
//  Created by Shawn Gee on 3/24/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import Foundation

enum Mood: String, CaseIterable {
    case sad, neutral, happy
    
    var emoji: String {
        switch self {
        case .sad:
            return "🙁"
        case .neutral:
            return "😐"
        case .happy:
            return "😀"
        }
    }
}
