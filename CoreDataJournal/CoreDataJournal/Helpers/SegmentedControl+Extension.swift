//
//  SegmentedControl+Extension.swift
//  CoreDataJournal
//
//  Created by Benjamin Hakes on 1/15/19.
//  Copyright © 2019 Benjamin Hakes. All rights reserved.
//

import Foundation
import UIKit

extension UISegmentedControl {
    
    func defaultConfiguration(font: UIFont = UIFont.systemFont(ofSize: 12), color: UIColor = UIColor.gray) {
        let defaultAttributes = [
            NSAttributedString.Key.foregroundColor.rawValue: color
        ]
        setTitleTextAttributes(defaultAttributes, for: .normal)
    }
    
    func selectedConfiguration(font: UIFont = UIFont.boldSystemFont(ofSize: 12), color: UIColor = UIColor.red) {
        let selectedAttributes = [
            NSAttributedString.Key.foregroundColor.rawValue: color
        ]
        setTitleTextAttributes(selectedAttributes, for: .selected)
    }
}
