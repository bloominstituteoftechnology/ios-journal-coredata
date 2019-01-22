
import UIKit

class EntryTableViewCell: UITableViewCell {

    @IBOutlet weak var titleOutlet: UILabel!
    
    @IBOutlet weak var bodyOutlet: UILabel!
    
    @IBOutlet weak var timestampOutlet: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
