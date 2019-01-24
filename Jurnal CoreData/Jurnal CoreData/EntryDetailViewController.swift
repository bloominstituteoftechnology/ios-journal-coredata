//
//  EntryDetailViewController.swift
//  Jurnal CoreData
//
//  Created by Sergey Osipyan on 1/21/19.
//  Copyright © 2019 Sergey Osipyan. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    var entryController: EntryController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
    }
    
    
    
    func updateViews() {
        guard isViewLoaded == true else { return }
        
        let mood = entry?.moodFace ?? .😐
        let moodIndex = MoodFace.allCases.index(of: mood)!
        segmentedOutlet.selectedSegmentIndex = moodIndex

        if let data = entry {
        textField.text = data.title
        textView.text = data.bodyText
       // entryController?.update(entry: data, title: data.title!, bodyText: data.bodyText!, mood: data.mood!, identifier: data.identifier!)
        //segmentedOutlet.selectedSegmentIndex = data.mood
        title = data.title
        } else {
            title = "Create Entry"
        }
    }
    
   
    @IBAction func segmentedControl(_ sender: Any) {
        
    }
     @IBOutlet weak var segmentedOutlet: UISegmentedControl!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textView: UITextView!
    
    @IBAction func saveButton(_ sender: Any) {
        
        guard let title = textField.text, let body = textView.text else {
            return
        }
        let moodIndex = segmentedOutlet.selectedSegmentIndex
        let mood = segmentedOutlet.titleForSegment(at: moodIndex)!
        
        if let entry = entry {
            
           
           entryController?.update(entry: entry, title: title, bodyText: body, mood: mood)
            print(entry)
            
        } else  {
            
            entryController?.create(title: title, bodyText: body, mood: mood, identifier: entry?.identifier)
        }
            navigationController?.popViewController(animated: true)
    }
}
