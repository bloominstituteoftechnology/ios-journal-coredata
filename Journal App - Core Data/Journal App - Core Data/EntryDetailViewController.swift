
import UIKit

class EntryDetailViewController: UIViewController {

    @IBOutlet weak var titleOutlet: UITextField!
    @IBOutlet weak var bodyOutlet: UITextView!
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    var entryController: EntryController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
        
        view.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        
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
        
        let maybeTitle = titleOutlet.text
        
        guard let title = maybeTitle, title.isEmpty == false else {
            return
        }
        
        let maybeBody = bodyOutlet.text
        
        guard let bodyText = maybeBody, bodyText.isEmpty == false else {
            return
        }
        
        if let entry = entry {
            
            // editing an entry
            entryController?.updateEntry(entry: entry, title: title, bodyText: bodyText)
            
            // Save the entry
            entryController?.saveToPersistentStore()
            
            // If saved successfully, pop back to the table view
            navigationController?.popViewController(animated: true)
            
        } else {
            print("Creating entry")
            // creating a new entry
            entryController?.createEntry(title: title, bodyText: bodyText)
            
            // Save the entry
            entryController?.saveToPersistentStore()
            
            // If saved successfully, pop back to the table view
            navigationController?.popViewController(animated: true)
            
        }
        


    }
    


}
