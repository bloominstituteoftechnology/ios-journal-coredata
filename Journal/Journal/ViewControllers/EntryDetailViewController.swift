//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Hector Steven on 5/28/19.
//  Copyright © 2019 Hector Steven. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
	
	@IBAction func saveButton(_ sender: Any) {
		print("save")
		navigationController?.popViewController(animated: true)
	}
	
	@IBOutlet var titleTextField: UITextField!
	@IBOutlet var bodyTextView: UITextView!
}
