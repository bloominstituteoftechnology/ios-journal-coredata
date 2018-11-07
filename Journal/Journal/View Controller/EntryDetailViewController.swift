import UIKit

class EntryDetailViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBAction func saveButton(_ sender: Any) {
        guard let entryController = entryController,
            let titleText = textField.text,
            let bodyText = textView.text else { return }
        
        let moodIndex = segmentedControl.selectedSegmentIndex
        let mood = Moods.allMoods[moodIndex]
        
        guard let entry = entry else {
            entryController.createEntry(with: titleText, bodyText: bodyText, mood: mood)
            navigationController?.popViewController(animated: true)
            return
        }
        
        entryController.update(entry: entry, with: titleText, bodyText: bodyText, mood: mood)
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
