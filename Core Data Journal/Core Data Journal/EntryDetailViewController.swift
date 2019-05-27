//
//  EntryDetailViewController.swift
//  Core Data Journal
//
//  Created by Michael Redig on 5/27/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
	var entryController: EntryController?
	var entry: Entry?

	@IBOutlet var titleTextField: UITextField!
	@IBOutlet var entryTextView: UITextView!
	
	@IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
	}
}

