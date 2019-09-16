//
//  JournalDetailViewController.swift
//  Journal
//
//  Created by Alex Rhodes on 9/16/19.
//  Copyright © 2019 Alex Rhodes. All rights reserved.
//

import UIKit
import CoreData

class JournalDetailViewController: UIViewController {
    
    var journal: Journal?
    
    var journalController: JournalController?
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
    }
    
    func setViews() {
        
        title = journal?.title ?? ""
        
        textField.text = journal?.title
        textView.text = journal?.bodyText
        
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        
        let timeInterval = TimeInterval(NSDate().timeIntervalSince1970)
        let time   = Date(timeIntervalSince1970: timeInterval)
        
        guard let title = textField.text,
            let body = textView.text else {return}
        
        if let journal = journal {
            journalController?.updateTask(journal: journal, with: title, bodyText: body, identifier: "", time: time)
        } else {
            journalController?.createJournal(with: title, bodyText: body, identifier: "", time: time)
        }
        
        navigationController?.popViewController(animated: true)
    }
}
