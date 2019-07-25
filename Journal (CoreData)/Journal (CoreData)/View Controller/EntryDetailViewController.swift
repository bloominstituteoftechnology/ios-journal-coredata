//
//  EntryDetailViewController.swift
//  Journal (CoreData)
//
//  Created by Nathan Hedgeman on 7/22/19.
//  Copyright © 2019 Nate Hedgeman. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    //Properties
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    var entryController: EntryController?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        
        // Do any additional setup after loading the view.
    }
    
    func updateViews() {
        
        guard isViewLoaded else { return }
        
        // fixes bug blanked out smileyfaced
        let attributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        segmentedControl.setTitleTextAttributes(attributes, for: .selected)
        
        let mood: MoodLevel
        if let entryMood = entry?.mood {
            mood = MoodLevel(rawValue: entryMood)!
        } else {
            mood = .normal
        }
        
        self.title = self.entry?.title ?? "Create Entry"
        self.titleTextField.text = entry?.title
        self.bodyTextView.text = entry?.bodyText
        segmentedControl.selectedSegmentIndex = MoodLevel.allMoods.firstIndex(of: mood)!
    }
    
    @IBAction func saveButton(_ sender: Any) {
        
        guard let title = titleTextField.text,
              let bodyText = bodyTextView.text else { return }
        
        let mood = MoodLevel.allMoods[segmentedControl.selectedSegmentIndex]
    
        //guard let entry = entry else { return }
        
        if (entry != nil) {
            
            guard let thisEntry = entry else {return}
            
            entryController?.updateEntry(entry: thisEntry, title: title, bodyText: bodyText, mood: mood.rawValue)
            navigationController?.popViewController(animated: true)
        } else {
            entryController?.createEntry(title: title, bodyText: bodyText, mood: mood.rawValue)
            navigationController?.popViewController(animated: true)
        }
    }
    
    func returnEnumCase(mood: String) {
        
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
