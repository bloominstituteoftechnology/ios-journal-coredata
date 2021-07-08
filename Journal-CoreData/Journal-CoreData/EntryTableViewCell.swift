//
//  EntryTableViewCell.swift
//  Journal-CoreData
//
//  Created by Jerrick Warren on 11/6/18.
//  Copyright © 2018 Jerrick Warren. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var entry: Entry? {
        didSet{
            updateViews()
        }
    }
    
    func updateViews() {
        //guard let title = entry?.title, !title.isEmpty else {return}
        guard let entry = entry else { return }
        titleLabel.text = entry.title
        bodyLabel.text = entry.bodyText
        if let date = entry.timeStamp {
            timeLabel.text = DateFormatter().string(from: date)
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .medium
            timeLabel.text = formatter.string(from: date)
            
        }
        
        
    }

    // MARK: - Properties
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    
    
    
}
