//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Breena Greek on 4/24/20.
//  Copyright © 2020 Breena Greek. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    // MARK: - Properties
    var entry: Entry?
    var wasEdited: Bool = false
    
    // MARK: - IBOutlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var moodControl: UISegmentedControl!
    @IBOutlet weak var bodyTextField: UITextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: UIBarButtonItem.Style.plain, target: self, action: nil)
        
        updateViews()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func updateViews() {
        guard let entry = entry else { return }
        titleTextField.text = entry.title
        titleTextField.isUserInteractionEnabled = isEditing
        
//        moodControl.selectedSegmentIndex = entry.mood
        
        bodyTextField.text = entry.bodyText
        bodyTextField.isUserInteractionEnabled = isEditing
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if editing == true {
            wasEdited = true
            titleTextField.isUserInteractionEnabled = editing
            bodyTextField.isUserInteractionEnabled = editing
            navigationItem.hidesBackButton = editing
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if wasEdited == true {
            guard let title = titleTextField.text,
                !title.isEmpty else { return }
            
            guard let body = bodyTextField.text,
                !body.isEmpty else { return }
            
            let selctedPriority = moodControl.selectedSegmentIndex
            let mood = Mood.allCases[selctedPriority]
            
            Entry(title: title,
                  bodyText: body,
                  mood: mood,
                  context: CoreDataStack.shared.mainContext)
            
            do {
                try CoreDataStack.shared.mainContext.save()
                navigationController?.dismiss(animated: true, completion: nil)
            } catch {
                NSLog("Error saving manage object context: \(error)")
            }
        }
    }
}
