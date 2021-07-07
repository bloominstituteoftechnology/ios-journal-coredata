//  Copyright © 2019 Frulwinn. All rights reserved.

import UIKit

class TableViewCell: UITableViewCell {
    
    //MARK: Properties
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var storyLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    

    func updateViews() {
        guard let entry = entry else { return }
        
        nameLabel.text = entry.title
        storyLabel.text = entry.bodyText
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d/yy, h:mm a"
        let timestampFormatted = dateFormatter.string(from: (entry.timestamp)!)
        
        timestampLabel.text = timestampFormatted
    }
}
