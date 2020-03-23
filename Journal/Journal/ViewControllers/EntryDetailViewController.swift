//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Bradley Diroff on 3/23/20.
//  Copyright © 2020 Bradley Diroff. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    @IBOutlet var textField: UITextField!
    @IBOutlet var textView: UITextView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func save(_ sender: Any) {
    }
    
    @IBAction func cancel(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
}

