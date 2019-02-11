//
//  EntryTableViewCell.swift
//  CoreJournal
//
//  Created by Jocelyn Stuart on 2/11/19.
//  Copyright © 2019 JS. All rights reserved.
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
        didSet {
            updateViews()
        }
    }
    var entryController: EntryController?
    
    let dateFormatter = DateFormatter()
    
    func updateViews() {
        guard let entry = entry else { return }
        
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        let timeText = dateFormatter.string(from: entry.timestamp!)
        
        titleTextField.text = entry.title
        timestampLabel.text = timeText
        bodyLabel.text = entry.bodyText
    }
    
    @IBOutlet weak var titleTextField: UILabel!
    
    @IBOutlet weak var bodyLabel: UILabel!
    
    @IBOutlet weak var timestampLabel: UILabel!
    
    
    
    
    

}
