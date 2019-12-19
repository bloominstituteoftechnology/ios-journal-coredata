//
//  TitleTextField.swift
//  Journal
//
//  Created by Chad Rutherford on 12/17/19.
//  Copyright © 2019 Chad Rutherford. All rights reserved.
//

import UIKit

class TitleTextField: UITextField {
    let padding = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
