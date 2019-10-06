//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Fabiola S on 10/2/19.
//  Copyright © 2019 Fabiola Saga. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    @IBOutlet weak var entryTitleTextField: UITextField!
    @IBOutlet weak var entryBodyTextView: UITextView!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    
    var entryController: EntryController?
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        guard let title = entryTitleTextField.text, !title.isEmpty,
            let body = entryBodyTextView.text else { return }
        if let entry = entry {
            entryController?.editEntry(entry: entry, title: title, bodyText: body)
        } else {
            entryController?.addEntry(title: title, bodyText: body)
        }
        
        navigationController?.popViewController(animated: true)
        
        
    }
    
   private func updateViews() {
        guard isViewLoaded else { return }
        title = entry?.title ?? "Create Entry"
        entryTitleTextField.text = entry?.title
        entryBodyTextView.text = entry?.bodyText
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
