//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Jordan Christensen on 9/17/19.
//  Copyright © 2019 Mazjap Co Technologies. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    var entryController: EntryController?
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var journalEntryTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        
        setUI()
    }
    
    func setUI() {
        navigationController?.navigationBar.barTintColor = .background
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.textColor]
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.textColor]
        
        titleTextField.backgroundColor = .textFieldBackground
        titleTextField.attributedPlaceholder = NSAttributedString(string: "Enter Title:",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        titleTextField.textColor = .textColor
        
        journalEntryTextView.layer.borderWidth = 0.5
        journalEntryTextView.layer.borderColor = UIColor(displayP3Red: 0.2, green: 0.2, blue: 0.2, alpha: 0.3).cgColor
        journalEntryTextView.layer.cornerRadius = 6
        journalEntryTextView.backgroundColor = .textFieldBackground
        journalEntryTextView.textColor = .textColor
        
        view.backgroundColor = .background
    }
    
    func updateViews() {
        if isViewLoaded {
            title = entry?.title ?? "Create Journal Entry"
            
            titleTextField.text = entry?.title
            journalEntryTextView.text = entry?.bodyText
        }
    }
    
    @IBAction func saveTapped(_ sender: UIButton) {
        guard let title = titleTextField.text,
            let bodyText = journalEntryTextView.text,
            !title.isEmpty, !bodyText.isEmpty else { return }
        if let entry = entry {
            entryController?.updateEntry(entry: entry, with: title, bodyText: bodyText)
        } else {
            entryController?.createEntry(with: title, bodyText: bodyText)
            
        }
        dismiss(animated: true, completion: nil)
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
