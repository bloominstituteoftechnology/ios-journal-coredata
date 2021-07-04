//
//  Journal
//
//  Created by Jonathan Ferrer on 6/5/19.
//  Copyright © 2019 Jonathan Ferrer. All rights reserved.
//

import Foundation
import CoreData

struct EntryRepresentation: Codable, Equatable {

    var identifier: UUID
    var title: String
    var bodyText: String?
    var timestamp: Date?
    var mood: EntryMood


}
func ==(lhs: EntryRepresentation, rhs: Entry ) -> Bool {
    return rhs == lhs
}

func ==(lhs: Entry, rhs: EntryRepresentation ) -> Bool {
    return rhs == lhs
}

func !=(lhs: EntryRepresentation, rhs: Entry ) -> Bool {
    return !(rhs == lhs)
}

func !=(lhs: Entry, rhs: EntryRepresentation ) -> Bool {
    return rhs != lhs
}
