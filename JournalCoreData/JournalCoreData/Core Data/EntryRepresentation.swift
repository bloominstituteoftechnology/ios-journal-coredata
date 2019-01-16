import Foundation

struct EntryRepresentation: Decodable, Equatable {
    
    var bodyText: String?
    var identifier: String?
    var mood: String?
    var timeStamp: Date?
    var title: String?
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
