//
//  EntryDetailViewController.swift
//  Journal - CoreData
//
//  Created by Nichole Davidson on 4/20/20.
//  Copyright © 2020 Nichole Davidson. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var entryTextView: UITextView!
    
    // MARK: - Properties
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    var entryController: EntryController?

    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }
    
    func updateViews() {
        viewDidLoad()
        
        if ((entry?.title) != nil)  {
        self.title = entry?.title
        } else {
            self.title = "Create Entry"
        }
        
        if entry != nil {
            titleTextField.text = entry?.title
            entryTextView.text = entry?.bodyText
        }
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        guard let title = titleTextField.text,
            !title.isEmpty else { return }
        
       guard let entryText = entryTextView.text,
        !entryText.isEmpty else { return }
        
        if entry != nil {
            entryController?.update(entry: entry!)
        } else {
            entryController?.create(entry: entry!)
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
