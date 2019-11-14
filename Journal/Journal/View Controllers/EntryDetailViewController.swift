//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by morse on 11/10/19.
//  Copyright © 2019 morse. All rights reserved.
//

import UIKit
import CoreData

class EntryDetailViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var moodSegmentedControl: UISegmentedControl!
    
    
    // MARK: - Properties
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    // MARK: - Setup
    private func updateViews() {
        guard isViewLoaded else { return }
        
        moodSegmentedControl.layer.cornerRadius = 4
        moodSegmentedControl.layer.cornerCurve = .continuous
        moodSegmentedControl.layer.borderWidth = 1
        moodSegmentedControl.layer.borderColor = UIColor(displayP3Red: 207/255, green: 207/255, blue: 207/255, alpha: 1.0).cgColor
        
        textView.layer.cornerRadius = 4
        textView.layer.cornerCurve = .continuous
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor(displayP3Red: 207/255, green: 207/255, blue: 207/255, alpha: 1.0).cgColor
        
        if let mood = Mood(rawValue: entry?.mood ?? Mood.😐.rawValue),
            let moodIndex = Mood.allCases.firstIndex(of: mood) {
            moodSegmentedControl.selectedSegmentIndex = moodIndex
        }
        
        title = entry?.title ?? "Create entry"
        titleTextField.text = entry?.title
        textView.text = entry?.bodyText
    }
    
    // MARK: - Actions
    
    @IBAction func saveTapped(_ sender: Any) {
        guard let title = titleTextField.text, let bodyText = textView.text else { return }
        
        let moodIndex =  moodSegmentedControl.selectedSegmentIndex
        let mood = Mood.allCases[moodIndex]
        
        if let entry = entry {
            entry.title = title
            entry.bodyText = bodyText
            entry.mood = mood.rawValue
            entry.timestamp = Date()
            
            APIController.put(entry: entry)
        } else {
            let entry = Entry(title: title, bodyText: bodyText, mood: mood.rawValue)
            APIController.put(entry: entry)
        }
        
        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
        
        navigationController?.popViewController(animated: true)
    }
}

