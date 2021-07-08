//
//  EntryDetailVC.swift
//  Journal Core Data
//
//  Created by Seschwan on 7/10/19.
//  Copyright © 2019 Seschwan. All rights reserved.
//

import UIKit

class EntryDetailVC: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var notesTextView:  UITextView!
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    var entryController: EntryController?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        borderUpdate()
        updateViews()

    }
    

    private func borderUpdate() {
        let borderWidth: CGFloat  = 1
        let borderRadius: CGFloat = 5
        let borderColor = UIColor.lightGray.cgColor
        
        titleTextField.layer.borderColor = borderColor
        notesTextView.layer.borderColor  = borderColor
        
        titleTextField.layer.borderWidth = borderWidth
        notesTextView.layer.borderWidth  = borderWidth
        
        titleTextField.layer.cornerRadius = borderRadius
        notesTextView.layer.cornerRadius  = borderRadius
        
    }
    
    private func updateViews() {
        guard isViewLoaded else { return }
        self.navigationItem.title = entry?.title ?? "Create Entry"
        titleTextField.text       = entry?.title
        notesTextView.text        = entry?.bodyText
        
    }
    
    // MARK: - Actions and Methods
    
    @IBAction func saveBtnPressed(_ sender: UIBarButtonItem) {
        guard let entryTitle = titleTextField.text, !entryTitle.isEmpty,
            let entryNotes = notesTextView.text, !entryNotes.isEmpty else {
                return
        }
        if let entry = entry {
            entryController?.update(entry: entry, title: entryTitle, bodyText: entryNotes)
        } else {
            entryController?.createEntry(title: entryTitle, bodyText: entryNotes)
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

}
