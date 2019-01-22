
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
        
        // guard entry and date here
        
        titleOutlet.text = entry?.title
        bodyOutlet.text = entry?.bodyText
        timestampOutlet.text = "\(entry?.timestamp)"
        
    }
    
}
