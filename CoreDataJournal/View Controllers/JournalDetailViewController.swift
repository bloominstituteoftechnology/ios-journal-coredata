//
//  JournalDetailViewController.swift
//  CoreDataJournal
//
//  Created by Austin Potts on 9/16/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class JournalDetailViewController: UIViewController {

    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var journalTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    @IBAction func save(_ sender: Any) {
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
