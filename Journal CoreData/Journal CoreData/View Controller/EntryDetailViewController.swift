//
//  EntryDetailViewController.swift
//  Journal CoreData
//
//  Created by Iyin Raphael on 9/24/18.
//  Copyright © 2018 Iyin Raphael. All rights reserved.
//

import UIKit 
import CoreData


class EntryDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    func updateViews(){
        if isViewLoaded {
            title =  entry?.title
            titleTextField.text = entry?.title
            textView.text = entry?.bodyText
            
            let mood: moodType
            if let selectMood = entry?.mood {
                mood = moodType(rawValue: selectMood)!
            }else {
                mood = .normal
            }
            segmentControl.selectedSegmentIndex = moodType.allMoods.index(of: mood)!
        }
    }
    
    var entry: Entry?{
        didSet{
            updateViews()
        }
    }
    
    @IBAction func save(_ sender: Any) {
        guard let title = titleTextField.text,
        let bodyText = textView.text else {return}
        let indexMood = segmentControl.selectedSegmentIndex
        let currentMood = moodType.allMoods[indexMood]
        
        if let entry = entry{
            entryController.updateEntry(entry: entry, title: title, bodyText: bodyText, mood: currentMood.rawValue)
        }else{
            entryController.createEntry(title: title, bodyText: bodyText)
        }
       navigationController?.popViewController(animated: true)
    }
    
    let entryController = EntryController()
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var textView: UITextView!
    

}
