import UIKit


class EntryTableViewCell: UITableViewCell {
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    func updateViews() {
        
        guard let entry = entry else { return }
        
        titleLabel.text = entry.title
        bodyLabel.text = entry.bodyText
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        
        timeLabel.text = formatter.string(from: entry.timestamp ?? Date())
    }
}

