//
//  TaskRepresentation.swift
//  Tasks
//
//  Created by Julian A. Fordyce on 6/5/19.
//  Copyright © 2019 Glas Labs. All rights reserved.
//

import Foundation

struct TaskRepresentation: Codable, Equatable {
    
    var name: String
    var notes: String?
    var priority: TaskPriority
    var identifier: UUID // all tasks on ther server must have an identifier
    

    
    
    
}
