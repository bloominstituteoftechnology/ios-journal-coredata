//
//  ViewController.swift
//  Journal
//
//  Created by Percy Ngan on 10/14/19.
//  Copyright © 2019 Lamdba School. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

	@IBOutlet weak var titleTextField: UITextField!
	@IBOutlet weak var textViewField: UITextView!

	// MARK: - Properties
	var entry: Entry?
	var entryController: EntryController?

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
	}

	@IBAction func saveButtonTapped(_ sender: Any) {
	}
	


}

