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

    
    @IBOutlet weak var entryTitleLabel: UILabel!
    @IBOutlet weak var entryTimestampLabel: UILabel!
    @IBOutlet weak var entryBodySummaryLabel: UILabel!
}
