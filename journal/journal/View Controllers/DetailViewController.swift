//  Copyright © 2019 Frulwinn. All rights reserved.

import UIKit

class DetailViewController: UIViewController {
    
    //MARK: - Properties
    var entryController: EntryController?
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var storyView: UITextView!
    @IBAction func save(_ sender: Any) {
        guard let title = nameTextField.text, !title.isEmpty,
        let bodyText = storyView.text else { return }
        
        let moodIndex = segmentedControl.selectedSegmentIndex
        let mood = JournalMood.allMoods[moodIndex]

        if let entry = entry {
            entryController?.update(entry: entry, title: title, bodyText: bodyText, mood: mood.rawValue)
    
        } else {
            entryController?.create(title: title, bodyText: bodyText, mood: mood)
        }
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    func updateViews() {
//        if isViewLoaded {
//            guard let entry = entry else {
//                title = "Create Entry"
//                return
        guard isViewLoaded else { return }
        guard let entry = entry else {
            title = "Create Entry"
            segmentedControl.selectedSegmentIndex = 1
            return
            }
        
            title = entry.title
            nameTextField.text = entry.title
            storyView.text = entry.bodyText
        
        var index: Int = 1
        switch entry.mood {
        case JournalMood.sad.rawValue:
            index = 0
        case JournalMood.meh.rawValue:
            index = 1
        case JournalMood.happy.rawValue:
            index = 2
        default:
            index = 1
        }
        segmentedControl.selectedSegmentIndex = index
    }
}

