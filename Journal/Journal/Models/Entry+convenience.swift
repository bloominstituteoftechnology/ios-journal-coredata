//
//  Entry+convenience.swift
//  Journal
//
//  Created by brian vilchez on 9/16/19.
//  Copyright © 2019 brian vilchez. All rights reserved.
//

import UIKit
import CoreData
extension Entry {

    convenience init(title:String,bodyText:String,identifier:String,timeStamp:Date, context: NSManagedObjectContext) {
        
        self.init(context: context)
        self.title = title
        self.timeStamp = timeStamp
        self.bodyText = bodyText
        self.identifier = identifier
    }

  
}
