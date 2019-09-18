//
//  TaskRepresentation.swift
//  CoreDataJournal
//
//  Created by Austin Potts on 9/18/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation


struct TaskRepresentation: Codable {
    
    let title: String
    let journalNote: String?
    let mood: String
    let identifier: String
    
}
