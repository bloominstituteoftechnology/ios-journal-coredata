//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Hector Steven on 5/28/19.
//  Copyright © 2019 Hector Steven. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
		updateViews()
		titleTextField.delegate = self
    }
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		
		print("textField delegate")
		return true
	}
	
	private func updateViews() {
		guard isViewLoaded else { return }
		
		if let entry = entry {
			title = entry.title
			titleTextField?.text = entry.title
			bodyTextView?.text = entry.bodyText
		} else {
			title = "Create Journal"
		}
	}
	
	@IBAction func saveButton(_ sender: Any) {
		guard let title = titleTextField.text, let body = bodyTextView.text else { return }
		
		if title.isEmpty || body.isEmpty {
			simpleAlert(title: "Error", message: "Your title/body is Empty.")
		}
		
		if let entry = entry {
			entry.title = title
			entry.bodyText = body
			entry.timeStamp = Date()
		} else {
			let _ = Entry(title: title, bodyText: body)
		}
		
		do {
			try CoreDataStack.shared.mainContext.save()
		} catch {
			NSLog("Failed To Save: \(error)")
		}
		
		navigationController?.popViewController(animated: true)
	}
	
	func simpleAlert(title: String, message: String) {
		let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: "Ok", style: .cancel))
		present(ac, animated: true)
	}
	
	
	@IBOutlet var titleTextField: UITextField!
	@IBOutlet var bodyTextView: UITextView!
	var entry: Entry? { didSet { updateViews() } }
}
