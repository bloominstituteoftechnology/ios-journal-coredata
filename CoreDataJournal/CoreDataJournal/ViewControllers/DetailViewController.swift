//
//  DetailViewController.swift
//  CoreDataJournal
//
//  Created by Benjamin Hakes on 1/14/19.
//  Copyright © 2019 Benjamin Hakes. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
    }
    
    @IBOutlet weak var entryTextField: UITextField!
    @IBOutlet weak var entryTextView: UITextView!
    @IBOutlet weak var smileySegmentedControl: UISegmentedControl!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .darkColor
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func save(_ sender: Any) {
        
        // check to make sure title is NOT empty
        guard let title = entryTextField.text, !title.isEmpty else {
            return
        }
        
        let bodyText = entryTextView.text
        let moodIndex = smileySegmentedControl.selectedSegmentIndex
        let mood = EntryMood.allCases[moodIndex]
        
        if let entry = entry {
            // editing existing entry
            entry.title = title
            entry.bodyText = bodyText
            entry.mood = mood.rawValue
            entryController?.put(entry: entry)
        } else {
            // create a new entry - after the MOC knows about the new entry
            entryController?.createEntry(title: title, mood: mood, bodyText: bodyText)
        }
        
        // we think this is a good opportunity to save the
        let moc = CoreDataStack.shared.mainContext
        do {
            try moc.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
        
        navigationController?.popViewController(animated: true)
        
    }
    
    private func updateViews(){
        guard isViewLoaded else {return}
        
        title = entry?.title ?? "Create Entry"
        entryTextField.text = entry?.title
        entryTextView.text = entry?.bodyText
        
        let mood = entry?.entryMood ?? .😐
        let moodIndex = EntryMood.allCases.index(of: mood)!
        smileySegmentedControl.selectedSegmentIndex = moodIndex
        
    }

    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    var entryController: EntryController?
    
}
