
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
        
        view.backgroundColor = #colorLiteral(red: 0.9921568627, green: 0.9884961752, blue: 0.5945744201, alpha: 1)
        moodSegmentedControl.backgroundColor = #colorLiteral(red: 0.8547534134, green: 0.9634845294, blue: 1, alpha: 1)
        moodSegmentedControl.tintColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)

    }
    

    
    func updateViews() {
        
        // Make sure the view is loaded
        guard isViewLoaded == true else { return }
        
        // Set view controller's title
        if let data = entry {
            title = data.title
            titleOutlet.text = data.title
            bodyOutlet.text = data.bodyText
            moodSegmentedControl.selectedSegmentIndex = MoodState.allMoods.index(of: data.moodState)!
        } else {
            title = "Create Entry"
        }
        
//        var moodState: MoodState
        
        // put in save func
//        if var moodState = entry?.moodState {
//            moodState = MoodState(rawValue: moodState.rawValue)!
//        } else {
//            moodState = .😐
//        }
        
        
        
    }
    
    @IBAction func save(_ sender: Any) {
        
        guard let titleText = titleOutlet.text, let bodyText = bodyOutlet.text else { return }
        
        let moc = CoreDataStack.shared.mainContext
        
        // Holds corresponding mood
        let moodIndex = moodSegmentedControl.selectedSegmentIndex
        let selectedMood = MoodState.allMoods[moodIndex]
        
        if let entry = entry {
            // Editing existing journal
            entryController?.updateEntry(entry: entry, title: titleText, bodyText: bodyText, mood: selectedMood.rawValue)

        } else {
            // Creating new journal
            entryController?.createEntry(title: titleText, bodyText: bodyText, mood: selectedMood.rawValue)
        }
        
        do {
            try moc.save()
            
            navigationController?.popViewController(animated: true)
            
        } catch {
            fatalError("Failed to save: \(error)")
        }
        

        

        


    }
    


}
