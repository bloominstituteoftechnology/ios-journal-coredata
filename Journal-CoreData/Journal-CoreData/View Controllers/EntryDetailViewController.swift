//
//  EntryDetailViewController.swift
//  Journal-CoreData
//
//  Created by Ciara Beitel on 9/16/19.
//  Copyright © 2019 Ciara Beitel. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    var entryController: EntryController?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var storyTextView: UITextView!
    
    @IBAction func saveTapped(_ sender: Any) {
        guard let titleTextField = titleTextField.text, let storyTextView = storyTextView.text else { return }
        
        if let entry = entry {
            entryController?.updateEntry(entry: entry, title: titleTextField, bodyText: storyTextView)
        } else {
            entryController?.createEntry(title: titleTextField, bodyText: storyTextView, timestamp: Date(), identifier: titleTextField)
        }
        
        navigationController?.popViewController(animated: true)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()

        // Do any additional setup after loading the view.
    }
    
    func updateViews() {
        if isViewLoaded == true {
            title = entry?.title ?? "Create Entry"
            titleTextField.text = entry?.title
            storyTextView.text = entry?.bodyText
        }
        
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


