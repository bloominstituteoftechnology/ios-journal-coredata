//
//  ViewController.swift
//  Journal
//
//  Created by Morgan Smith on 4/22/20.
//  Copyright © 2020 Morgan Smith. All rights reserved.
//

import UIKit

class CreateEntryViewController: UIViewController {
    
    var dateFormatter: DateFormatter {
           let formatter = DateFormatter()
           formatter.dateFormat = "MMM/dd/yy, HH:mm"
           formatter.timeZone = TimeZone(secondsFromGMT: 0)
           return formatter
       }
    @IBOutlet weak var journalMood: UISegmentedControl!
    
    @IBOutlet weak var journalTitle: UITextField!
    
    @IBOutlet weak var journalText: UITextView!
    
    @IBAction func cancelButton(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    let timestamp = Date()
    
    var entryController: EntryController?
    
    
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
    
        // Grab the individual values from the views
        guard let title = journalTitle.text, !title.isEmpty else { return }
           
        let bodyText = journalText.text
        
        let selectedMood = journalMood.selectedSegmentIndex
        let mood = EntryMood.allCases[selectedMood]
          
          // timestamp = DateFormatter.string(from: timestamp)
           
        let entry = Entry(title: title, timestamp: timestamp, bodyText: bodyText, mood: mood)
        
        entryController?.sendEntryToServer(entry: entry)
        
           do {
               try CoreDataStack.shared.mainContext.save()
               navigationController?.dismiss(animated: true, completion: nil)
           } catch {
               NSLog("Error saving manage object contedxt: \(error)")
           }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

