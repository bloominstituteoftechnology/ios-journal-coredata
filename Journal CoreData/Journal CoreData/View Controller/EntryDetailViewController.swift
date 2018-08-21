//
//  EntryDetailViewController.swift
//  Journal CoreData
//
//  Created by Ngozi Ojukwu on 8/20/18.
//  Copyright © 2018 iyin. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        updateView()
    }

    
    @IBAction func Save(_ sender: Any) {
        guard let name = nameTextField.text,
            !name.isEmpty,
            let bodyText = bodytextView.text else { return }
        
        let selectedMood = EntryMood.allMoods[segmentButtonCon.selectedSegmentIndex]
        
        if let entry = entry {
            entryController?.updateEntry(entry: entry, name: name, bodyText: bodyText, mood: selectedMood.rawValue)
        } else {
            entryController?.createEntry(name: name, bodyText: bodyText, mood: selectedMood.rawValue)
        }
        navigationController?.popViewController(animated: true)
    }
    
    
    func updateView(){
        if isViewLoaded{
            
            title = entry?.name ?? "Create Entry"
            nameTextField.text = entry?.name
            bodytextView.text = entry?.bodyText
            
            guard let moodString = entry?.mood,
                let mood = EntryMood(rawValue: moodString) else {return}
            
            segmentButtonCon.selectedSegmentIndex = EntryMood.allMoods.index(of: mood)!
        }
    }
    
    @IBOutlet weak var segmentButtonCon: UISegmentedControl!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var bodytextView: UITextView!
    
    
    
   
    
    var entry: Entry?{
        didSet{
            updateView()
        }
    }
    var entryController: EntryController?
    

}
