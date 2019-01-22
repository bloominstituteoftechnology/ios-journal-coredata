
import UIKit

class EntryTableViewCell: UITableViewCell {

    @IBOutlet weak var titleOutlet: UILabel!
    
    @IBOutlet weak var bodyOutlet: UILabel!
    
    @IBOutlet weak var timestampOutlet: UILabel!
    
    static let reuseIdentifier = "entrycell"
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        
        titleOutlet.text = entry?.title
        bodyOutlet.text = entry?.bodyText
        timestampOutlet.text = "\(entry?.timestamp)"
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
