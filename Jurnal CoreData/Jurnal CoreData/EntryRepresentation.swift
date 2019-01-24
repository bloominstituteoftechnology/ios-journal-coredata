//
//  EntryRepresentation.swift
//  Jurnal CoreData
//
//  Created by Sergey Osipyan on 1/23/19.
//  Copyright © 2019 Sergey Osipyan. All rights reserved.
//

import Foundation


struct EntryRepresentation: Decodable, Equatable {
    
    
    let bodyText: String?
    let identifier: String?
    let mood: String?
    let timestamp: Date?
    let title: String?
}

 func == (lhs: EntryRepresentation, rhs: Entry) -> Bool{
    
    return lhs.identifier == rhs.identifier
}

 func == (lhs: Entry, rhs: EntryRepresentation) -> Bool {
    
    return rhs == lhs
}

func != (lhs: EntryRepresentation, rhs: Entry) -> Bool{
    
    return !(rhs == lhs)
}

func != (lhs: Entry, rhs: EntryRepresentation) -> Bool {
    
    return rhs != lhs
}
