
import Foundation
import UIKit
import CoreData

class EntryCell:UITableViewCell
{
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var etextLabel: UILabel!
	@IBOutlet weak var dateLabel: UILabel!
	var entry:JournalEntry! {
		didSet {
			titleLabel.text = entry.title
			etextLabel.text = entry.text
			let df = DateFormatter()
			df.dateFormat = "dd/mm/yy HH:mm"
			dateLabel.text = df.string(from: entry.timestamp!)
		}
	}
}
