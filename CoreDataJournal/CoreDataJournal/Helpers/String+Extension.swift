//
//  String+Extension.swift
//  CoreDataJournal
//
//  Created by Benjamin Hakes on 1/14/19.
//  Copyright © 2019 Benjamin Hakes. All rights reserved.
//

import UIKit

extension String {
    
    static func dateToString(date: Date) -> String{
        
        // formatter #1
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "yyyy-MM-dd"
        let dateString1 = formatter1.string(from: date)
        
        // formatter #2
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "HH:mm"
        let dateString2 = formatter2.string(from: date)
        
        // combine
        let returnString = "\(dateString1), \(dateString2)"
        return returnString
        
    }
    
    
    
}
