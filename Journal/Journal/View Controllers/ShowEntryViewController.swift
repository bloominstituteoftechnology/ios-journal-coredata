//
//  ShowEntryViewController.swift
//  Journal
//
//  Created by Cameron Collins on 4/22/20.
//  Copyright © 2020 Cameron Collins. All rights reserved.
//

import UIKit

class ShowEntryViewController: UIViewController {

    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
    
    //MARK: - Variables
    var entry: Entry?
    var canEdit = false
    
    
    //MARK: - Actions
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        canEdit = !canEdit
    }
    
    //MARK: - Outlet
    @IBOutlet weak var segmentedControlMood: UISegmentedControl!
    @IBOutlet weak var textFieldTitle: UITextField!
    @IBOutlet weak var textViewDescription: UITextView!
    
    //MARK: - Functions
    
    //Updates Views
    func updateView() {
        textFieldTitle.text = entry?.title
        textViewDescription.text = entry?.bodyText
        
        var mood: Int = 0
        
        switch entry?.mood {
        case MoodType.happy.rawValue:
            mood = 0
        case MoodType.moderate.rawValue:
            mood = 1
        case MoodType.unhappy.rawValue:
            mood = 2
        default:
            mood = 1
        }
        
        segmentedControlMood.selectedSegmentIndex = mood
    }

}

