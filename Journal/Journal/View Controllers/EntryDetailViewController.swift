import UIKit

class EntryDetailViewController: UIViewController {
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    var entryController: EntryController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
    }
    
    func updateViews() {
        if isViewLoaded {
            guard let entry = entry else { return }
            
            title = entry.title ?? "Create Task"
            entryTextField.text = entry.title
            entryTextView.text = entry.bodyText
        }
    }
    
    @IBOutlet weak var entryTextField: UITextField!
    @IBOutlet weak var entryTextView: UITextView!
    
    @IBAction func saveEntry(_ sender: Any) {
        
        
    }
    
    
}
