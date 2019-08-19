//
//  EntryDetailViewController.swift
//  Journal-CoreData
//
//  Created by Marlon Raskin on 8/19/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

	@IBOutlet weak var titleStaticLabel: UILabel!
	@IBOutlet weak var titleTextField: UITextField!
	@IBOutlet weak var bodyStaticLabel: UILabel!
	@IBOutlet weak var bodyTextView: UITextView!

	var entry: Entry?
	var entryController: EntryController?


    override func viewDidLoad() {
        super.viewDidLoad()
		setupUI()
	}
    
	@IBAction func saveTapped(_ sender: UIBarButtonItem) {
	}



	private func setupUI() {
		bodyTextView.layer.borderWidth = 1
		bodyTextView.layer.borderColor = UIColor(red: 0.66, green: 0.85, blue: 0.85, alpha: 1.00).cgColor
		bodyTextView.layer.cornerRadius = 6
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
