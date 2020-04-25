//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Morgan Smith on 4/25/20.
//  Copyright © 2020 Morgan Smith. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    
    @IBOutlet weak var journalMood: UISegmentedControl!
      
      @IBOutlet weak var journalTitle: UITextField!
      
      @IBOutlet weak var journalText: UITextView!
    
    var entry: Entry?
    var wasEdited: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let editButtonItem = UIBarButtonItem()
        navigationItem.rightBarButtonItem = editButtonItem
        updateViews()
    }
    
    func updateViews() {
        guard let entry = entry else { return }
        
        journalMood.selectedSegmentIndex = EntryMood.allCases.firstIndex(of: EntryMood(rawValue: entry.mood!)!) ?? 1
        
        journalTitle.text = entry.title
        journalText.text = entry.bodyText
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
