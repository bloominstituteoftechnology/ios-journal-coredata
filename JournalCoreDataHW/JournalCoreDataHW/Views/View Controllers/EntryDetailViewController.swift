//
//  EntryDetailViewController.swift
//  JournalCoreDataHW
//
//  Created by Michael Flowers on 5/28/19.
//  Copyright © 2019 Michael Flowers. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    var ec: EntryController?

    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var bodyTV: UITextView!
    @IBOutlet weak var segmentedProperties: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    

    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        guard let title = titleTF.text, !title.isEmpty, let body = bodyTV.text, !body.isEmpty else { return }
        
        guard let passedInEntry = entry else {
            //create new entry
            ec?.createEntry(title: title, bodyText: body)
            navigationController?.popViewController(animated: true)
            return
        }
        //udpate
        ec?.update(entry: passedInEntry, newTitle: title, newBodyText: body, newTimestamp: Date())
        navigationController?.popViewController(animated: true)
        
    }
    
    private func updateViews(){
        guard let passedInEntry = entry, isViewLoaded else {
            title = "Create Entry"
            return }
        titleTF.text = passedInEntry.title
        bodyTV.text = passedInEntry.bodyText
        title = passedInEntry.title
    }
}
