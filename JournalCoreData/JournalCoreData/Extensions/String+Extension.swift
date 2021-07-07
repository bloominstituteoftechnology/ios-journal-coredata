//
//  String+Extension.swift
//  JournalCoreData
//
//  Created by Nelson Gonzalez on 2/11/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import UIKit

extension String {
    
    static func dateToString(date: Date) -> String{
        
        // formatter #1
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "MM-dd-yyyy"
        formatter1.dateStyle = .short
        formatter1.timeStyle = .short
        let dateString1 = formatter1.string(from: date)
        
        let returnString = "\(dateString1)"
        return returnString
        
    }
}

