//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Lydia Zhang on 3/23/20.
//  Copyright © 2020 Lydia Zhang. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textBody: UITextView!
    @IBOutlet weak var segmentBar: UISegmentedControl!
    
    
    var entry: Entry? {
        didSet {
            updateView()
        }
    }
    var entryController: EntryController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
        // Do any additional setup after loading the view.
    }
    
    func updateView() {
        guard isViewLoaded else {return}
        guard let entry = entry else {
            title = "Create a New Journal"
            textField.text = " "
            textBody.text = " "
            segmentBar.selectedSegmentIndex = 0
            textField.becomeFirstResponder()
            return
        }
        title = entry.title
        textField.text = entry.title
        textBody.text = entry.bodyText
        
        switch entry.mood {
        case Mood.sad.rawValue:
            segmentBar.selectedSegmentIndex = 2
        case Mood.neutral.rawValue:
            segmentBar.selectedSegmentIndex = 1
        default:
            segmentBar.selectedSegmentIndex = 0
        }
    }
    @IBAction func save(_ sender: Any) {
        guard let title = textField.text,
            let body = textBody.text,
            !title.isEmpty, !body.isEmpty else {
                return
        }
        let mood = Mood.allMoods[segmentBar.selectedSegmentIndex]
        if let entry = entry, let entryController = entryController {
            entryController.updateLocal(entry: entry, title: title, bodyText: body, mood: Mood(rawValue: mood.rawValue)!, context: CoreDataStack.shared.mainContext)
        } else if let entryController = entryController {
            entryController.create(title: title, bodyText: body, mood: mood, context: CoreDataStack.shared.mainContext)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    

}
