//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Jonathan Ferrer on 6/3/19.
//  Copyright © 2019 Jonathan Ferrer. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    var entry: Entry?
    var entryController: EntryController?
    
}
