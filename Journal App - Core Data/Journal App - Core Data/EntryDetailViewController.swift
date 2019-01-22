
import UIKit

class EntryDetailViewController: UIViewController {

    @IBOutlet weak var titleOutlet: UITextField!
    @IBOutlet weak var bodyOutlet: UITextView!
    @IBOutlet weak var moodSegmentedControl: UISegmentedControl!
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    var entryController: EntryController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
        
        view.backgroundColor = #colorLiteral(red: 0.5617739458, green: 0.783548178, blue: 0.8114779287, alpha: 1)
        moodSegmentedControl.backgroundColor = #colorLiteral(red: 0.8547534134, green: 0.9634845294, blue: 1, alpha: 1)
        moodSegmentedControl.tintColor = #colorLiteral(red: 0.6328204675, green: 0.8546559514, blue: 0.9921568627, alpha: 1)

        
    }
    
    func updateViews() {
        
        // Make sure the view is loaded
        guard isViewLoaded == true else { return }
        
        // Set view controller's title
        if let e = entry {
            title = e.title
            titleOutlet.text = e.title
            bodyOutlet.text = e.bodyText
        } else {
            title = "Create Entry"
        }
    }
    
    @IBAction func save(_ sender: Any) {
        
        guard let titleText = titleOutlet.text, let bodyText = bodyOutlet.text else { return }
        
        if let entry = entry {
            entryController?.updateEntry(entry: entry, title: titleText, bodyText: bodyText)
        } else {
            //print("Creating Entry")
            entryController?.createEntry(title: titleText, bodyText: bodyText)
        }
        navigationController?.popViewController(animated: true)
        
//        let maybeTitle = titleOutlet.text
//
//        guard let title = maybeTitle, title.isEmpty == false else { return }
//
//        let maybeBody = bodyOutlet.text
//
//        guard let bodyText = maybeBody, bodyText.isEmpty == false else { return }
//
//        if let entry = entry {
//
//            // editing an entry
//            entryController?.updateEntry(entry: entry, title: title, bodyText: bodyText)
//
//            // Save the entry
//            entryController?.saveToPersistentStore()
//
//            // If saved successfully, pop back to the table view
//            navigationController?.popViewController(animated: true)
//
//        } else {
//            print("Creating entry")
//            // creating a new entry
//            entryController?.createEntry(title: title, bodyText: bodyText)
//
//            // Save the entry
//            entryController?.saveToPersistentStore()
//
//            // If saved successfully, pop back to the table view
//            navigationController?.popViewController(animated: true)
//
//        }
        


    }
    


}
