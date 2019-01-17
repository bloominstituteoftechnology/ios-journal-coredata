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
    
    
    @IBAction func saveEntry(_ sender: UIBarButtonItem) {
        print("save button tapped")
        let entryTitle = titleEntryTextField.text
        let entryBody = entryBodyTextView.text
        let currentMood = moodSegmentedControl.titleForSegment(at: moodSegmentedControl.selectedSegmentIndex)
        print("assigned the values")
        guard let title = entryTitle, title.isEmpty == false else {
            print("something is wrong here. either titles mismatch or field is empty")
            return}

        print("title isnt empty")
    
        if let existingEntry = entry {
            print("this is an existing entry")
            if existingEntry.identifier == entry?.identifier {
                print("identifiers match: \(existingEntry.identifier, entry?.identifier). updateEntry called")
                entryController?.updateEntry(title: entryTitle!, entryBodyText: entryBody!, mood: currentMood!, entry: existingEntry)
            }


            //FIXME: STUPID createEntry func won't fire here, entryController seems to be nil in the else clause. Doesnt seem like any functions are firing here, only prints and declarations.
        } else {
            print("this is a new entry. this should be creating a new entry for \(entryTitle!)")
//            entryController?.createEntry(title: entryTitle!, entryBody: entryBody, mood: currentMood!)
//
//            entryController?.put(entry: entry!)
//
            let newEntry = Entry(title: title, bodyText: entryBody!, identifier: UUID().uuidString, mood: currentMood!, context: CoreDataStack.shared.mainContext) //yep
            print(newEntry) //yep
            entryController?.saveToPersistentStore() // nope
            entryController?.put(entry: newEntry) //nope
            print("putted")//yep
            entryController?.updateEntry(title: title, entryBodyText: entryBody!, mood: currentMood!, entry: entry!)//nope
            print("updated")//yep
        }
    
        //navigationController?.popViewController(animated: true)
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
