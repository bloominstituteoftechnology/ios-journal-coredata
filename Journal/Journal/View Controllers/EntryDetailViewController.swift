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
        
        let mood: EntryMood
        if let entryMood = entry?.mood {
            mood = EntryMood(rawValue: entryMood)!
        } else {
            mood = .😐
        }
        moodControl.selectedSegmentIndex = EntryMood.allCases.index(of: mood)!
        
    }
    
    @IBOutlet weak var entryTextField: UITextField!
    @IBOutlet weak var entryTextView: UITextView!
    @IBOutlet weak var moodControl: UISegmentedControl!
    
    @IBAction func saveEntry(_ sender: Any) {
        
        guard let title = entryTextField.text, !title.isEmpty else { return }
        guard let body = entryTextView.text, !body.isEmpty else { return }
        let moodIndex = moodControl.selectedSegmentIndex
        let mood = EntryMood.allCases[moodIndex]
        
        
        if let entry = entry {
            entryController?.updateEntry(entry: entry, title: title, bodyText: body, mood: mood.rawValue)
        } else {
            entryController?.createEntry(title: title, bodyText: body, mood: mood.rawValue)
        }
        
        navigationController?.popViewController(animated: true)
    }
}
