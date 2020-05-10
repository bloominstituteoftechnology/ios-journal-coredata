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
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var storyView: UITextView!
    @IBAction func save(_ sender: Any) {
        guard let title = nameTextField.text, !title.isEmpty,
        let bodyText = storyView.text else { return }
        Entry(title: title, bodyText: bodyText)
        
        do {
            let moc = CoreDataStack.shared.mainContext
            try entryController?.saveToPersistentStore()
        } catch {
            NSLog ("error saving managed object context: \(error)")
        }
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    func updateViews() {
        if isViewLoaded {
            guard let entry = entry else {
                title = "Create Entry"
                return
            }
            title = entry.title
            nameTextField.text = entry.title
            storyView.text = entry.bodyText
        }
    }
}

