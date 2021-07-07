//
//  EntryCell.swift
//  Journal (Core Data)
//
//  Created by Simon Elhoej Steinmejer on 14/08/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import UIKit

class EntryCell: UITableViewCell
{
    let timestampLabel: UILabel =
    {
        let label = UILabel()
        label.textAlignment = .right
        label.sizeToFit()
        
        return label
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(timestampLabel)
        timestampLabel.anchor(top: topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 0, paddingRight: 8, paddingBottom: 0, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
