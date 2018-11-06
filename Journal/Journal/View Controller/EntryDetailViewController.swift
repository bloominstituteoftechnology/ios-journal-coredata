import UIKit

class EntryDetailViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBAction func saveButton(_ sender: Any) {
        guard let title = textField.text, !title.isEmpty else {return}
        guard let text = textView.text, !text.isEmpty else {return}
        let priorityIndex = segmentedControl.selectedSegmentIndex
        let priority = Moods.allCases[priorityIndex]
        
        if let entry = entry {
            entry.title = title
            entry.bodyText = text
            entry.mood = priority.rawValue
            //entryController?.updateEntry(entry: entry, title: title, bodyText: text, mood: priority)
        } else {
            //entryController?.newEntry(title: title, bodyText: text, mood: priority.rawValue)
            _ = Entry(title: title, bodyText: text, mood: priority.rawValue)
        }
        
        let moc = CoreDataStack.shared.mainContext
        do {
            try moc.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
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
        let mood = Moods.neutral.rawValue
        
        segmentedControl.selectedSegmentIndex = Moods.allCases.map({$0.rawValue}).index(of: mood)!
        
        
//        let mood: Moods
//        if let moodPriority = entry?.mood {
//            mood = Moods(rawValue: moodPriority)!
//        } else {
//            print("why won't you be happy xcode")
//            //mood = "😢"
//        }
        //segmentedControl.selectedSegmentIndex = Moods.allCases.index(of: mood)!
    }
}
