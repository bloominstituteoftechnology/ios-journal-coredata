import UIKit

class EntryDetailViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {

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
    
    
    @IBOutlet weak var moodSegmentedControl: UISegmentedControl!
    @IBOutlet weak var titleEntryTextField: UITextField!
    @IBOutlet weak var entryBodyTextView: UITextView!
    
    
    @IBAction func saveEntry(_ sender: Any) {
        print("saving")
        let entryTitle = titleEntryTextField.text
        let entryBody = entryBodyTextView.text
        let currentMood = moodSegmentedControl.titleForSegment(at: moodSegmentedControl.selectedSegmentIndex)
        guard let title = entryTitle, title.isEmpty == false else {return}

        
        if let existingEntry = entry {
            entryController?.updateEntry(title: entryTitle!, entryBodyText: entryBody!, mood: currentMood!, entry: existingEntry)
            //navigationController?.popViewController(animated: true)


        } else {
//            print("this should be creating a new entry for \(entryTitle)")
//            entryController?.createEntry(title: entryTitle!, entryBody: entryBody, mood: currentMood!)
//
            let newEntry = Entry(title: title, bodyText: entryBody!, identifier: UUID().uuidString, mood: currentMood!, context: CoreDataStack.shared.mainContext)
            entryController?.put(entry: newEntry)
        }
        navigationController?.popViewController(animated: true)
//
    }
    
    func updateViews(){
        guard isViewLoaded == true else {return}
        self.navigationItem.title = entry?.title ?? "Create Entry"
        titleEntryTextField.text = entry?.title
        entryBodyTextView.text = entry?.bodyText
        switch entry?.mood {
        case "🧬":
            moodSegmentedControl.selectedSegmentIndex = 0
            
        case "🧠":
            moodSegmentedControl.selectedSegmentIndex = 2
            
        default:
            moodSegmentedControl.selectedSegmentIndex = 1
        }
        
        
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
