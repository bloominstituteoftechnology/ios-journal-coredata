
import Foundation

struct EntryRepresentation: Decodable, Equatable {
    
    let title: String
    let bodyText: String
    let timestamp: Date
    let identifier: String
    let mood: String

}

func == (lhs: EntryRepresentation, rhs: Entry) -> Bool {
    
    // Check to see if same identifiers
    return lhs.identifier == rhs.identifier
}

func == (lhs: Entry, rhs: EntryRepresentation) -> Bool {
    return rhs == lhs
}

func != (lhs: EntryRepresentation, rhs: Entry) -> Bool {
    return !(rhs == lhs)
}

func != (lhs: Entry, rhs: EntryRepresentation) -> Bool {
    return rhs != lhs
}


