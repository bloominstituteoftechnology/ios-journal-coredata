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
	
//	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//		
//		print("textField delegate")
//		return true
//	}
	
	private func updateViews() {
		guard isViewLoaded else { return }
		
		if let entry = entry {
			title = entry.title
			titleTextField?.text = entry.title
			bodyTextView?.text = entry.bodyText
			moodSegementControl.selectedSegmentIndex = getMoodIndex(mood: entry.mood!)
		} else {
			title = "Create Journal"
		}
	}
	
	@IBAction func saveButton(_ sender: Any) {
		guard let title = titleTextField.text, let body = bodyTextView.text else { return }
		
		if (title.isEmpty && title.count < 20) || body.isEmpty {
			simpleAlert(title: "Error", message: "Your title/body is Empty.")
		}
		
		let mood = getMood(i: moodSegementControl.selectedSegmentIndex)
		

		if let entry = entry {
			entry.title = title
			entry.bodyText = body
			entry.timeStamp = Date()
			entry.mood = mood
		} else {
			let _ = Entry(title: title, bodyText: body, mood: mood)
		}
		
		
		
		do {
			let moc = CoreDataStack.shared.mainContext
			try moc.save()
		} catch {
			NSLog("Failed To Save: \(error)")
			simpleAlert(title: "Error", message: "Maybe your title is longer then 20 char.")
			return
		}

		print(mood)
		navigationController?.popViewController(animated: true)
	}
	
	func getMood(i: Int) -> String {
		switch i {
		case 0:
			return "😁"
		case 1:
			return "😅"
		case 2:
			return "😱"
		default:
			return ""
		}
	}
	
	func getMoodIndex(mood: String) -> Int{
		switch mood {
		case "😁":
			return 0
		case "😅":
			return 1
		case "😱":
			return 2
		default:
			return 0
		}
	}
	func simpleAlert(title: String, message: String) {
		let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: "Ok", style: .cancel))
		present(ac, animated: true)
	}
	
	
	@IBOutlet var moodSegementControl: UISegmentedControl!
	@IBOutlet var titleTextField: UITextField!
	@IBOutlet var bodyTextView: UITextView!
	var entry: Entry? { didSet { updateViews() } }
}
