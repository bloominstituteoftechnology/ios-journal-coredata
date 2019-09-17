//
//  EntryDetailViewController.swift
//  JournalCoreData
//
//  Created by Marc Jacques on 9/16/19.
//  Copyright © 2019 Marc Jacques. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    var entryController: EntryController!
    
    @IBOutlet weak var entryTitle: UITextField!
    @IBOutlet weak var entryText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()       
    }
    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        guard let title = entryTitle.text else { return }
        let journalEntry  = entryText.text
        
        if let entry = entry {
            entryController.updateEntry(entries: entry, title: title, bodyText: journalEntry)
        } else {
            entryController.createAnEntry(title: title, bodyText: journalEntry)
        }
        navigationController?.popViewController(animated: true)
    }
    func updateViews() {
        guard let entry = entry else { return }
        title = entry.title
        entryTitle.text = entry.title
        entryText.text = entry.bodyText
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
