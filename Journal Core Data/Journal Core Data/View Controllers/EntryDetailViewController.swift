//
//  EntryDetailViewController.swift
//  Journal Core Data
//
//  Created by Bhawnish Kumar on 3/23/20.
//  Copyright © 2020 Bhawnish Kumar. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    var entry: Entry?
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
        Entry(title: name, bodyText: notes, timeStamp: Date(), mood: mood, context: CoreDataStack.shared.mainContext)
        do {
            try CoreDataStack.shared.mainContext.save()
            navigationController?.dismiss(animated: true, completion: nil)
        } catch {
            NSLog("error saving managed obejct context: \(error)")
            
        }

        
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
