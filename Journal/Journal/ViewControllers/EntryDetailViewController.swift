//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Bradley Diroff on 3/23/20.
//  Copyright © 2020 Bradley Diroff. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    var entryController: EntryController?
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet var textField: UITextField!
    @IBOutlet var textView: UITextView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }

    @IBAction func save(_ sender: Any) {
        
        guard let title = textField.text,
            !title.isEmpty,
            let desc = textView.text,
            !desc.isEmpty
            else {
                return
        }
        let moodIndex = segmentControl.selectedSegmentIndex
        let mood = FaceValue.allCases[moodIndex]
        if let entry = entry {
            entryController?.update(entry: entry, title: title, bodyText: desc, mood: mood)
        } else {
            entryController?.create(title: title, bodyText: desc, mood: mood)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func updateViews() {
        
        guard let _ = textField, let _ = textView else {return}
        
        if let entry = entry {
            self.title = entry.title
            textField.text = entry.title
            textView.text = entry.bodyText
            if let index = FaceValue.allCases.firstIndex(where: {$0.rawValue == entry.mood}) {
                segmentControl.selectedSegmentIndex = index
            }
        }
    }
    
}

