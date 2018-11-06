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
        guard isViewLoaded else { return }
            
        title = entry?.title ?? "Create New Entry"
        entryTextField.text = entry?.title
        entryTextView.text = entry?.bodyText

    }
    
    @IBOutlet weak var entryTextField: UITextField!
    @IBOutlet weak var entryTextView: UITextView!
    
    @IBAction func saveEntry(_ sender: Any) {
        
        guard let title = entryTextField.text, !title.isEmpty else { return }
        guard let body = entryTextView.text, !body.isEmpty else { return }
        
        if let entry = entry {
            entryController?.updateEntry(entry: entry, title: title, bodyText: body)
        } else {
            entryController?.createEntry(title: title, bodyText: body)
        }
        
        navigationController?.popViewController(animated: true)
    }
}
