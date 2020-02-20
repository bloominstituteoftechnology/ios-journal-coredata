//
//  EntryTableViewCell.swift
//  Journal (Core Data)
//
//  Created by David Wright on 2/12/20.
//  Copyright © 2020 David Wright. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    // MARK: - Properties

    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyTextLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    // MARK: - UpdateViews

    private func updateViews() {
        CoreDataStack.shared.mainContext.perform {
            guard let entry = self.entry,
                let timestamp = entry.timestamp else { return }
            
            self.titleLabel.text = entry.title
            self.bodyTextLabel.text = entry.bodyText
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .short
            self.timestampLabel.text = dateFormatter.string(from: timestamp)
        }
    }

}
