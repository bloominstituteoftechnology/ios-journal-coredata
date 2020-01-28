//
//  EntryDetailViewController.swift
//  Journal (Core Data)
//
//  Created by Michael on 1/27/20.
//  Copyright © 2020 Michael. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    var entryController: EntryController?
    
    @IBOutlet weak var entryTitleTextField: UITextField!
    @IBOutlet weak var entryBodyTextView: UITextView!
    @IBOutlet weak var moodControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }

    @IBAction func saveEntry(_ sender: Any) {
        guard let title = entryTitleTextField.text, let bodyText = entryBodyTextView.text else { return }
        var mood: Mood = .neutral
        switch moodControl.selectedSegmentIndex {
        case 0:
            mood = .sad
        case 1:
            mood = .neutral
        case 2:
            mood = .happy
        default:
            mood = .neutral
        }
        if let entry = entry {
            entryController?.updateEntry(for: entry, title: title, bodyText: bodyText, mood: mood.rawValue)
        } else {
            entryController?.createEntry(title: title, bodyText: bodyText, mood: mood.rawValue)
        }
        navigationController?.popViewController(animated: true)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func updateViews() {
        guard isViewLoaded else { return }
        
        title = entry?.title ?? "Create Entry"
        entryTitleTextField.text = entry?.title
        entryBodyTextView.text = entry?.bodyText
        switch entry?.mood {
        case Mood.sad.rawValue:
            moodControl.selectedSegmentIndex = 0
        case Mood.neutral.rawValue:
            moodControl.selectedSegmentIndex = 1
        case Mood.happy.rawValue:
            moodControl.selectedSegmentIndex = 2
        default:
            moodControl.selectedSegmentIndex = 1
        }
    }
}
