//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Sal Amer on 2/12/20.
//  Copyright © 2020 Sal Amer. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    var entryController: EntryController?
    
    
    
    //MARK - Outlets
    @IBOutlet weak var titleEntryLbl: UITextField!
    @IBOutlet weak var descriptionLbl: UITextView!
    @IBOutlet weak var emojiStatusControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }

    // MARK - Actions
    
    @IBAction func saveBtnPressed(_ sender: UIBarButtonItem) {
        print("save tapped")
        guard let title = titleEntryLbl.text,
            !title.isEmpty else { return }
       guard let descript = descriptionLbl.text,
        !descript.isEmpty else { return }
        
        if let entry = entry {
            entryController?.Update(entry: entry, newTitle: title, newBodyText: descript)
        } else {
            entryController?.CreateEntry(title: title, bodytext: descript, timestamp: Date(), identifier: "\(Int.random(in: 1...1000))")
        
        }
        navigationController?.popViewController(animated: true)
    }
    
    func updateViews() {
        guard isViewLoaded else { return }
        title = entry?.title ?? "Create Entry"
        titleEntryLbl.text = entry?.title
        descriptionLbl.text = entry?.description
    }
    

}

