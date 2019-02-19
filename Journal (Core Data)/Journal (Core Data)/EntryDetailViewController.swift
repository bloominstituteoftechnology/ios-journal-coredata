//
//  EntryDetailViewController.swift
//  Journal (Core Data)
//
//  Created by Julian A. Fordyce on 2/18/19.
//  Copyright © 2019 Glas Labs. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    var entryController: EntryController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        designButton()
    }
    
    func updateViews() {
        guard isViewLoaded else { return }
        
        if let entry = entry {
            titleTextField.text = entry.title
            entryTextField.text = entry.bodyText
            title = entry.title
        } else {
            title = "Create Entry"
        }
    }
    
    @IBAction func saveEntry(_ sender: Any) {
        guard let title = titleTextField.text, !title.isEmpty,
            let bodyText = entryTextField.text, !bodyText.isEmpty else { return }
        
        if let entry = entry {
            entryController?.updateEntry(entry: entry, title: title, bodyText: bodyText)
        } else {
            entryController?.createEntry(title: title, bodyText: bodyText)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    func designButton() {
        saveButton.layer.cornerRadius = saveButton.frame.width / 2
        saveButton.backgroundColor = UIColor.gray
        
        saveButton.layer.shadowOffset = CGSize.zero
        saveButton.layer.shadowColor = UIColor.black.cgColor
        saveButton.layer.shadowOpacity = 1
        
        saveButton.setTitleColor(.white, for: .normal)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - Properties
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var entryTextField: UITextView!
    @IBOutlet weak var saveButton: UIButton!
}
