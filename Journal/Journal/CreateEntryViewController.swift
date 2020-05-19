//
//  ViewController.swift
//  Journal
//
//  Created by Harmony Radley on 5/18/20.
//  Copyright © 2020 Harmony Radley. All rights reserved.
//

import UIKit

class CreateEntryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    // MARK: - Actions
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
           navigationController?.dismiss(animated: true, completion: nil)
       }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
    
    }
    
   

}

