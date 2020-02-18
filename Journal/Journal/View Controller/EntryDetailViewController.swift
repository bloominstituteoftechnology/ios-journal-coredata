//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Gerardo Hernandez on 2/12/20.
//  Copyright © 2020 Gerardo Hernandez. All rights reserved.
//

import UIKit
import CoreData

enum Mood: String {
    case unhappy = "🙁"
    case neutral = "😐"
    case happy = "🙂"
    
    static var allMoods: [Mood] {
        return [.unhappy, .neutral, .happy]
    }
    
    static var moodRawValues: [String] {
        return allMoods.compactMap { $0.rawValue }
    }
    
}
 
class EntryDetailViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    //MARK: Properties
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    var entryController: EntryController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        titleTextField.becomeFirstResponder()
        
        // Do any additional setup after loading the view.
    }
    
    func updateViews() {
        guard isViewLoaded else { return }
        
        if let entry = entry {
            title = entry.title
            titleTextField.text = entry.title
            textView.text = entry.bodyText
            if let moodString = entry.mood,
                let moodIndex = Mood.moodRawValues.firstIndex(of: moodString) {
                segmentedControl.selectedSegmentIndex = moodIndex
            } else {
                segmentedControl.selectedSegmentIndex = 1
            }
        } else {
            title = entry?.title ?? "Create Entry"
        }
    }
    
    @IBAction func saveEntry(_ sender: UIBarButtonItem) {
        
        guard let title = titleTextField.text,
            !title.isEmpty else { return }
        guard let bodyText = textView.text,
            !bodyText.isEmpty else { return }
       
        let mood = Mood.allMoods[segmentedControl.selectedSegmentIndex].rawValue
        
        if let entry = entry {
            entryController?.updateEntry(entry, newTitle: title, newbodyText: bodyText, updatedMood: mood)
        } else {
            entryController?.createEntry(title: title, bodyText: bodyText, mood: mood)
            
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    

}
