//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Daniela Parra on 9/17/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
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
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    
}
