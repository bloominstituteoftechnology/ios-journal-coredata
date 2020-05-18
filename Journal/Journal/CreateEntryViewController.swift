//
//  ViewController.swift
//  Journal
//
//  Created by Nonye on 5/18/20.
//  Copyright © 2020 Nonye Ezekwo. All rights reserved.
//

import UIKit

class CreateEntryViewController: UIViewController {
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var journalEntryTitleText: UITextField!
    
    @IBOutlet weak var journalTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    // MARK: - ACTIONS
    
    @IBAction func saveEntryTapped(_ sender: Any) {
    }
    
    @IBAction func cancelEntryTapped(_ sender: Any) {
    }
    
    
}

