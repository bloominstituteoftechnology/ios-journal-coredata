//
//  EntryDetailViewController.swift
//  Journal CoreData
//
//  Created by Moin Uddin on 9/17/18.
//  Copyright © 2018 Moin Uddin. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        // Do any additional setup after loading the view.
    }
    
    
    func updateViews() {
        if let entry = entry {
            titleTextField?.text = entry.title
            bodyTextView?.text = entry.bodyText
            title = entry.title
        } else {
            title = "New Entry"
        }
    }
    
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    
    @IBAction func saveEntry(_ sender: Any) {
        guard let title = titleTextField.text,
            let body = bodyTextView.text
            else { return }
        
        if let entry = entry {
            entryController?.updateEntry(entry: entry, title: title, bodyText: body)
        } else {
            entryController?.createEntry(title: title, bodyText: body)
        }
        navigationController?.popViewController(animated: true)
    }
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    var entryController: EntryController?
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
