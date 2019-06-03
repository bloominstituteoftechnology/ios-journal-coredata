//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Mitchell Budge on 6/3/19.
//  Copyright © 2019 Mitchell Budge. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - Properties
   
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var textView: UITextView!
    
    var entry: Entry?
    var entryController: EntryController?
}
