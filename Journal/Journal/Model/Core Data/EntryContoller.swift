//
//  EntryContoller.swift
//  Journal
//
//  Created by Shawn James on 4/22/20.
//  Copyright © 2020 Shawn James. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case noIdentifier
    case otherError
    case noData
    case noDecode
    case noEncode
    case noRep
}

let baseURL = URL(string: "https://journal-d5a9d.firebaseio.com/")!

class EntryController {
    
}
