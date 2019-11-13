//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Thomas Sabino-Benowitz on 11/11/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var entryTextView: UITextView!
    
    @IBOutlet weak var moodControl: UISegmentedControl!

    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        // Do any additional setup after loading the view.
    }
    

    @IBAction func saveEntry(_ sender: Any) {
        guard let title = titleTextField.text,
            !title.isEmpty else {return}
        let bodyText = entryTextView.text
        
        let moodIndex = moodControl.selectedSegmentIndex
        let mood = Mood.allCases[moodIndex]
        
        if let entry = entry {
            entry.bodyText = bodyText
            entry.mood = mood.rawValue
            entry.title = title
        } else {
            let _ = Entry(bodyText: bodyText, title: title, mood: mood)
        }
        
        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
            updateViews()
        } catch {
            print("Error saving managed object context: \(error)")
        }
        navigationController?.popViewController(animated: true)
    }
    
    private func updateViews() {
        guard isViewLoaded else {return}
        
        self.title = entry?.title ?? "Create A New Entry"
    
        titleTextField.text = entry?.title
        titleTextField.layer.borderColor = UIColor.black.cgColor
        titleTextField.layer.borderWidth = 2
        titleTextField.layer.cornerRadius = 6
        titleTextField.font = UIFont(name: "Futura", size: 32)
        
        entryTextView.text = entry?.bodyText ?? "Type your new entry here "
        entryTextView.layer.borderWidth = 2
        entryTextView.layer.cornerRadius = 12
        entryTextView.font = UIFont(name: "Verdana", size: 20)
        
        let mood: Mood
        if let entryMood = entry?.mood {
            mood = Mood(rawValue: entryMood)!
        } else {
            mood = .😺
        }
        moodControl.selectedSegmentIndex = Mood.allCases.firstIndex(of: mood)!
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
