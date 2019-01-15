import UIKit

class EntryTableViewCell: UITableViewCell {
    static let reuseIdentifier = "EntryCell"

//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//        // Configure the view for the selected state
//    }

    var entry: Entry? {
        didSet {
            updateViews(entry: entry!)
        }
    }
    
    func updateViews(entry: Entry) {
        
        entryTitleLabel.text = entry.title
        entryTimestampLabel.text = entry.timeStamp?.formatter?.string(from: entry.timeStamp!)
        entryBodySummaryLabel.text = entry.bodyText
        
        
    }
    
    
    @IBOutlet weak var entryTitleLabel: UILabel!
    @IBOutlet weak var entryTimestampLabel: UILabel!
    @IBOutlet weak var entryBodySummaryLabel: UILabel!
}
