//
//  EntryDetailViewController.swift
//  CoreJournal
//
//  Created by Jocelyn Stuart on 2/11/19.
//  Copyright © 2019 JS. All rights reserved.
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
    
    var entryController: EntryController?
    
    var entry: Entry? {
        didSet{
            updateViews()
        }
    }
    
    func updateViews() {
        
        if let entry = entry, isViewLoaded {
            title = entry.title
            
            titleTextField.text = entry.title
            bodyTextView.text = entry.bodyText
            
        } else {
            title = "Create New Entry"
        }
        
        
    }
    
    
    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        guard let title = titleTextField.text, let bodyText = bodyTextView.text else { return }
        
        if let entry = entry {
            entryController?.update(withEntry: entry, andTitle: title, andBody: bodyText)
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
            
        } else {
            entryController?.create(withTitle: title, andBody: bodyText)
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
          
        }
        
    }
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var bodyTextView: UITextView!
    
    
    
    

}
