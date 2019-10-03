//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Vici Shaweddy on 10/2/19.
//  Copyright © 2019 Vici Shaweddy. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    var entry: Entry?
    
    var entryController: EntryController?
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    private func updateViews() {
        self.textField.text = entry?.title
        self.textView.text = entry?.bodyText
        
        if entry == nil {
            self.navigationItem.title = "Create Entry"
        } else {
            self.navigationItem.title = entry?.title
        }
    }
    
    @IBAction func saveButton(_ sender: Any) {
        guard let textField = self.textField.text, !textField.isEmpty else { return }
        
        let textView = self.textView.text
        
        if let entry = entry {
            entryController?.update(entry: entry, title: textField, bodyText: textView ?? "")
        } else {
            entryController?.create(title: textField, bodyText: textView)

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
