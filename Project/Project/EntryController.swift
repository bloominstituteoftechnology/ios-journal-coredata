//
//  EntryController.swift
//  Project
//
//  Created by Ryan Murphy on 6/3/19.
//  Copyright © 2019 Ryan Murphy. All rights reserved.
//

import Foundation


func saveToPersistenStore() {
    
    do {
        let moc = CoreDataStack.shared.mainContrext
        try moc.save()
    }catch {
        NSLog("Error saving managed object context: \(error)")
    }
    
}
