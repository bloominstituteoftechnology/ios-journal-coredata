//
//  ViewController.swift
//  Journal
//
//  Created by Jarren Campos on 4/22/20.
//  Copyright © 2020 Jarren Campos. All rights reserved.
//

import UIKit

class CreateEntryViewController: UIViewController {

    //MARK: - Constants and Variables
    let timestamp = Date()
    //MARK: - Outlets
    @IBOutlet var journalEntryTitle: UITextField!
    @IBOutlet var journalBodyText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    //MARK: - Actions
    @IBAction func saveJournalEntry(_ sender: Any) {
        guard let title = journalEntryTitle.text else { return  }
        guard let bodyText = journalBodyText.text else { return }
//        let entry = Entry(identifier: "Placeholder", bodyText: bodyText, timestamp: timestamp, title: title)
        Entry(identifier: "Entry", bodyText: bodyText, timestamp: timestamp, title: title)
        do {
            try CoreDataStack.shared.mainContext.save()
            navigationController?.dismiss(animated: true, completion: nil)
        } catch {
            NSLog("error")
        }
    }
    @IBAction func cancelJounalEntry(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    


}

