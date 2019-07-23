//
//  EntryDetailViewController.swift
//  Journal (CoreData)
//
//  Created by Nathan Hedgeman on 7/22/19.
//  Copyright © 2019 Nate Hedgeman. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    //Properties
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    var entryController: EntryController?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        // Do any additional setup after loading the view.
    }
    
    func updateViews() {
        
        if (entry != nil) {
            
        title = entry?.title
        titleTextField.text = entry?.title
        bodyTextView.text = entry?.bodyText
            
        } else {
            
            title = "Create Entry"
        }
    }
    
    @IBAction func saveButton(_ sender: Any) {
        
        guard let title = titleTextField.text,
              let bodyText = bodyTextView.text else { return }
    
        //guard let entry = entry else { return }
        
        if (entry != nil) {
            
            guard let thisEntry = entry else {return}
            
            entryController?.updateEntry(entry: thisEntry, title: title, bodyText: bodyText)
            navigationController?.popViewController(animated: true)
        } else {
            entryController?.createEntry(title: title)
            navigationController?.popViewController(animated: true)
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
