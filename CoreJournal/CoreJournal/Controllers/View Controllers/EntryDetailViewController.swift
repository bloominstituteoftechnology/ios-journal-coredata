//
//  ViewController.swift
//  CoreJournal
//
//  Created by Aaron Cleveland on 1/27/20.
//  Copyright © 2020 Aaron Cleveland. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    var entryController: EntryController?

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var emojiControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if entry == nil {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveEntry))
        }
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        if let entry = entry {
//            guard let title = textField.text,
//                !title.isEmpty else {
//                    return
//            }
//            let bodyText = textView.text
//            let moodIndex = emojiControl.selectedSegmentIndex
//            let mood = Mood.allMoods[moodIndex]
//
//            entry.title = title
//            entry.bodyText = bodyText
//            entry.mood = mood.rawValue
//            do {
//                try CoreDataStack.shared.mainContext.save()
//            } catch {
//                NSLog("Error saving managed object context: \(error)")
//            }
//        }
//    }
    
    @objc func saveEntry() {
        guard let title = textField.text,
            let bodyText = textView.text else { return }
        var mood: Mood = .neutral
        switch emojiControl.selectedSegmentIndex {
        case 0:
            mood = .angry
        case 1:
            mood = .neutral
        case 2:
            mood = .happy
        default:
            mood = .neutral
        }
        if let entry = entry {
            entryController?.update(for: entry, title: title, bodyText: bodyText, mood: mood.rawValue)
        } else {
            entryController?.createEntry(title: title, bodyText: bodyText, mood: mood.rawValue)
        }
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    private func updateViews() {
        guard isViewLoaded else { return }

        title = entry?.title ?? "Create Entry"
        textField.text = entry?.title
        textView.text = entry?.bodyText
        switch entry?.mood {
        case Mood.angry.rawValue:
            emojiControl.selectedSegmentIndex = 0
        case Mood.neutral.rawValue:
            emojiControl.selectedSegmentIndex = 1
        case Mood.happy.rawValue:
            emojiControl.selectedSegmentIndex = 2
        default:
            emojiControl.selectedSegmentIndex = 1
        }
    }
}
