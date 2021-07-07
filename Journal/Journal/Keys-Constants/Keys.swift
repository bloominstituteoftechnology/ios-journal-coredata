//
//  Keys.swift
//  Journal
//
//  Created by Chris Gonzales on 2/24/20.
//  Copyright © 2020 Chris Gonzales. All rights reserved.
//

import Foundation

struct Keys{
    static let addEntrySegue: String = "AddJournalEntrySegue"
    static let viewEditEntrySegue: String = "JournalDetailSegue"
    
    static let entryCellName: String = "EntryTableViewCell"
    
    static let persistentContainerName: String = "Journal"
}

enum MoodEmojis: String, CaseIterable {
    case happy = "🥳"
    case blah = "🤨"
    case angry = "🤬"
}

