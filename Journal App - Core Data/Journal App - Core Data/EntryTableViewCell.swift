
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
    
    func convertDateFormatter(_ date: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +zzzz"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "MM-dd-yyyy hh:mm"
        return dateFormatter.string(from: date!)
        
    }
    
    func updateViews() {
        
        guard let entry = entry else { return }
        guard let date = entry.timestamp else { return }
        
        titleOutlet.text = entry.title
        bodyOutlet.text = entry.bodyText
        timestampOutlet.text = convertDateFormatter("\(date)")
        
    }
    
}
