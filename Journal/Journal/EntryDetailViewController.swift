//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Yvette Zhukovsky on 11/5/18.
//  Copyright © 2018 Yvette Zhukovsky. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        
        
        // Do any additional setup after loading the view.
    }
    
    
    
    
    
    var entry: Entry? {
        didSet{
            
            updateViews()
            
        }
        
    }
    
    
    
    
    var entryController: EntryController?
    
    func updateViews() {
        guard isViewLoaded else { return }
        
        title = entry?.title ?? "Create Entry"
        titleTextField.text = entry?.title
        textView.text = entry?.bodytext
        
    }
    
    
    
    
    @IBOutlet weak var titleTextField: UITextField!
    
    
    
    @IBOutlet weak var textView: UITextView!
    
    
    @IBAction func save(_ sender: Any) {
        guard let title = titleTextField.text else {return}
        guard let body = textView.text else {return}
        
        if let entry = entry  {
            entryController?.Update(entry: entry, title: title, bodytext: body)
        } else {
            entryController?.Create(title: title, bodytext: body)
        }
        self.navigationController?.popViewController(animated: true)
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
