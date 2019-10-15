//
//  DetailTableViewController.swift
//  ios-Journal-coredata
//
//  Created by Jonalynn Masters on 10/15/19.
//  Copyright © 2019 Jonalynn Masters. All rights reserved.
//

import UIKit

import UIKit

class DetailViewController: UIViewController {
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    var entryController: EntryController?
        
    
    // MARK: - Outlets
    @IBOutlet weak var entryTitle: UITextField!
    @IBOutlet weak var entryText: UITextView!
    @IBOutlet weak var moodSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    // MARK: - Actions
    @IBAction func save(_ sender: UIBarButtonItem) {
        if let title = entryTitle.text,
            let bodyText = entryText.text {
            
            let index = moodSegmentedControl.selectedSegmentIndex
            
            let mood: Mood
            
            if index == 0 {
                mood = .😁
            } else if index == 1 {
                mood = .😐
            } else {
                mood = .🥺
            }
            
            if let entry = entry {
                entryController?.updateEntry(entry: entry, with: title, bodyText: bodyText, mood: mood)
            } else {
                entryController?.createEntry(with: title, bodyText: bodyText, mood: mood, context: CoreDataStack.shared.mainContext)
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    func updateViews() {
        guard isViewLoaded else { return }
        
        title = entry?.title ?? "Create Entry"
        entryTitle.text = entry?.title
        entryText.text = entry?.bodyText
        
        if let mood = Mood(rawValue: entry?.mood ?? "😐"),
            let moodIndex = Mood.allCases.firstIndex(of: mood) {
            moodSegmentedControl.selectedSegmentIndex = moodIndex
        }
    }
}
