//
//  EntryDetailViewController.swift
//  JournalCoreData
//
//  Created by Angel Buenrostro on 2/11/19.
//  Copyright © 2019 Angel Buenrostro. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func updateViews(){
        
        guard let entry = entry, isViewLoaded else {
            self.navigationItem.title = "Create Entry"
            return
        }
        self.navigationItem.title = entry.title
        bodyText.text = entry.bodyText
    }
    
    // MARK: - Properties
    
    var entry: Entry? {
        didSet{
            updateViews()
        }
    }
    var entryController: EntryController?

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var bodyText: UITextView!
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let text = textField.text,
            let bodyText = bodyText.text else {
            print("Error with the texts")
            return
        }
        guard let entry = entry else {
            entryController?.createEntry(title: text, bodyText: bodyText)
            navigationController?.popViewController(animated: true)
            return
        }
        entryController?.updateEntry(title: text, bodyText: bodyText, entry: entry)
        navigationController?.popViewController(animated: true)
    }
}
