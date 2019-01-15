import Foundation

enum Moods: String, CaseIterable {
    
    case 🧬
    case 🦠
    case 🧠
    
}

extension Entry {
    
    var moods: Moods {
        get {
            return Moods(rawValue: mood!) ?? .🦠
        }
        
        set {
           mood = newValue.rawValue
        }
    }
}
