//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Clayton Watkins on 6/3/20.
//  Copyright © 2020 Clayton Watkins. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet weak var entryTitleLabel: UILabel!
    @IBOutlet weak var entryTimestampLabel: UILabel!
    @IBOutlet weak var entryTextLabel: UILabel!
    
    //MARK: - Properties
    var entry: Entry?{
        didSet{
            updateViews()
        }
    }
    
    //MARK: - Private Functions
    private func updateViews(){
        guard let entry = entry else { return }
        
        entryTitleLabel.text = entry.title
        entryTextLabel.text = entry.bodyText
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .short
        entryTimestampLabel.text = dateFormatter.string(from: entry.timestamp ?? Date())
        
    }
    
}
