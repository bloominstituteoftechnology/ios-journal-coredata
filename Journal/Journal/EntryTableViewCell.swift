//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Fabiola S on 10/2/19.
//  Copyright © 2019 Fabiola Saga. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var entryTitleLabel: UILabel!
    @IBOutlet weak var entryBodyLabel: UILabel!
    @IBOutlet weak var entryTimeLabel: UILabel!
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
  private func updateViews() {
        guard let entry = entry else { return }
        if let name = entry.title, let body = entry.bodyText, let date = entry.timeStamp {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            let dateString = formatter.string(from: date)
            
            entryTitleLabel.text = name
            entryBodyLabel.text = body
            entryTimeLabel.text = dateString
        }
        
        
    }
    
    

}
