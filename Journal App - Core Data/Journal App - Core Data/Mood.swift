
import Foundation

enum MoodState: String, CaseIterable {
    
    case 🤩
    case 😐
    case 😭
    
    static var allMoods: [MoodState] {
        return [.🤩, .😐, .😭]
    }
    
}

// This allows us not to have to call rawValue throughout the rest of the app
extension Entry {
    
    var moodState: MoodState {
        
        // in order to get the value
        get {
            return MoodState(rawValue: mood!) ?? .😐
        }
        
        set {
            mood = newValue.rawValue
        }
    }
}

// Case Iterable:
// A way to tell the compiler to build a function called allCases
// allCases is an array of every possible value in this enum

// let allPriorities = MoodState.allCases
