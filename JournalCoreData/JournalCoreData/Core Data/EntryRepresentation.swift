import Foundation

struct EntryRepresentation: Decodable, Equatable {
    
    let bodyText: String?
    let identifier: String?
    let mood: String?
    let timeStamp: Date?
    let title: String?
}

func ==(lhs: EntryRepresentation, rhs: Entry) -> Bool {
    return
        lhs.bodyText == rhs.bodyText &&
        lhs.identifier == rhs.identifier &&
        lhs.mood == rhs.mood &&
        lhs.timeStamp == rhs.timeStamp &&
        lhs.title == rhs.title
}

func ==(lhs: Entry, rhs: EntryRepresentation) -> Bool {
    return rhs == lhs
}

func !=(lhs: EntryRepresentation, rhs: Entry) -> Bool {
    return !(rhs == lhs)
}

func !=(lhs: Entry, rhs: EntryRepresentation) -> Bool {
    return rhs != lhs
}
