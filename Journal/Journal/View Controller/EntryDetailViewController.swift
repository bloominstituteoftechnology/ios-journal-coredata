import UIKit

class EntryDetailViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var textView: UITextView!
    
    @IBAction func saveButton(_ sender: Any) {
        guard let title = textField.text, !title.isEmpty else {return}
        guard let text = textView.text, !text.isEmpty else {return}
        
        if let entry = entry {
            entryController?.updateEntry(entry: entry, title: title, bodyText: text)
        } else {
            entryController?.newEntry(title: title, bodyText: text)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    var entry: Entry? {
        didSet{
            updateViews()
        }
    }
    var entryController: EntryController?
    
    func updateViews() {
        guard isViewLoaded else {return}
        
        title = entry?.title ?? "Create New Entry"
        textField.text = entry?.title
        textView.text = entry?.bodyText
    }
}
