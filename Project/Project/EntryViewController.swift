//
//  EntryViewController.swift
//  Project
//
//  Created by Ryan Murphy on 6/3/19.
//  Copyright © 2019 Ryan Murphy. All rights reserved.
//

import UIKit

class EntryViewController: UIViewController {

    @IBOutlet weak var journalTextView: UITextView!
    @IBOutlet weak var titleTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveJournalButtonPressed(_ sender: Any) {
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
