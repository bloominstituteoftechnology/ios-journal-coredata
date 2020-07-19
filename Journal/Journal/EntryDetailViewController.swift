//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by ronald huston jr on 7/19/20.
//  Copyright © 2020 HenryQuante. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    @IBOutlet weak var entryTextField: UITextField!
    @IBOutlet weak var diaryTextView: UITextView!
    @IBOutlet weak var moodSelector: UISegmentedControl!
    var wasEdited: Bool? = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  set editButtonItem to rightBarButtonItem
        
    }

}
