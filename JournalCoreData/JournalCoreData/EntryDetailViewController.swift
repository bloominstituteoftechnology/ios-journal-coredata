import UIKit

class EntryDetailViewController: UIViewController, UITextViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        // Do any additional setup after loading the view.
    }
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    var entryController: EntryController?
    
    @IBOutlet weak var titleEntryTextField: UITextField!
    @IBOutlet weak var entryBodyTextView: UITextView!
    
    
    @IBAction func saveEntry(_ sender: Any) {
        print("saving")
        let entryTitle = titleEntryTextField.text
        guard let title = entryTitle, title.isEmpty == false else {return}

        let entryBody = entryBodyTextView.text
        if let existingEntry = entry {
            entryController?.updateEntry(entryTitle: existingEntry.title!, entryBodyText: entryBody!, entry: existingEntry)
            navigationController?.popViewController(animated: true)


        } else {
//            print("this should be creating a new entry for \(entryTitle)")
//            entryController!.createEntry(title: entryTitle!, entryBody: entryBody)
            
            _ = Entry(title: title, bodyText: entryBody!, context: CoreDataStack.shared.mainContext)
        }

        do {
            try CoreDataStack.shared.mainContext.save()
            navigationController?.popViewController(animated: true)
        }catch {
            print("Failed to save: \(error)")
        }
    }
    
    func updateViews(){
        guard isViewLoaded == true else {return}
        self.navigationItem.title = entry?.title ?? "Create Entry"
        titleEntryTextField.text = entry?.title
        entryBodyTextView.text = entry?.bodyText
        
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
