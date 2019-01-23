//
//  EntryDetailViewController.swift
//  Journal: Core Data
//
//  Created by Ivan Caldwell on 1/22/19.
//  Copyright © 2019 Ivan Caldwell. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    var entry: Entry?{
        didSet{
            updateViews()
        }
    }
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var moodSegmentedControl: UISegmentedControl!
    
    func updateViews(){
        guard isViewLoaded == true else { return }
        if let e = entry {
            titleTextField.text = e.title
            bodyTextView.text = e.bodyText
            
            title = e.title
        } else {
            // createa task
            title = "Create Entry"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    

    @IBAction func saveButtonTapped(_ sender: Any) {
        let maybeName = titleTextField.text
        guard let title = maybeName, title.isEmpty == false else {
            return
        }
        let bodyText = bodyTextView.text
        
        if let existingEntry = entry {
            // editing a entry
            existingEntry.title = title
            existingEntry.bodyText = bodyText
        } else {
            // creating a new entry
            let newEntry = Entry(context: CoreDataStack.shared.mainContext)
            newEntry.title = title
            newEntry.bodyText = bodyText
        }
        
        do {
            try CoreDataStack.shared.mainContext.save()
            navigationController?.popViewController(animated: true)
        } catch {
            print("EntryDetailViewController: Line 61\nFailed to save: \(error)")
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
