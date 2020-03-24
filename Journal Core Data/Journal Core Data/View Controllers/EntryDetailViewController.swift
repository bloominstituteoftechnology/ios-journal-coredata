//
//  EntryDetailViewController.swift
//  Journal Core Data
//
//  Created by Bhawnish Kumar on 3/23/20.
//  Copyright © 2020 Bhawnish Kumar. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    var entryController: EntryController?
    
    @IBOutlet weak var entryTextField: UITextField!
    
    @IBOutlet weak var entryTextView: UITextView!
    
    @IBOutlet weak var moodControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        entryTextView.becomeFirstResponder()
        }
    
    
    @IBAction func cancelEntry(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveEntry(_ sender: UIBarButtonItem) {
        guard let name = entryTextView.text,
                   !name.isEmpty else {
                       return
               }
        let moodIndex = moodControl.selectedSegmentIndex
        let mood = EntryMood.allCases[moodIndex]
        guard let notes = entryTextView.text else { return }
        if let entry = entry {
            
            entryController?.updateEntry(entryTitle: name, bodyText: notes, entry: entry, mood: mood.rawValue)
        } else {
            if let entryController = entryController {
                entryController.createEntry(identifier: UUID(), title: name, bodyText: notes, timeStamp: Date(), mood: mood.rawValue)
            }
             navigationController?.popViewController(animated: true)
           
        }
        navigationController?.popViewController(animated: true)
        do {
            try CoreDataStack.shared.mainContext.save()
            navigationController?.dismiss(animated: true, completion: nil)
        } catch {
            NSLog("error saving managed obejct context: \(error)")
            
        }
      
    }
    
    func updateViews() {
              guard let entry = entry else { return }
              entryTextField.text = entry.title
              entryTextView.text = entry.bodyText
              title = entry.title
              
              let setMood = EntryMood(rawValue: entry.mood ?? "")
              guard let moodIndex = EntryMood.allCases.firstIndex(of: setMood!),
                  moodControl.selectedSegmentIndex == moodIndex
                  else {
                      return title = "Create Entry" }
          }
//     add
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
