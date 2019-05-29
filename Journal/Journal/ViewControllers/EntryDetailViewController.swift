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
	
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		updateViews()
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
		
		
		guard let title = titleTextField.text,
			let body = bodyTextView.text else { return }
		print("save")
		if let entry = entry {
			//editting a task
			entry.title = title
			entry.bodyText = body
			
		} else {
			//creating a new task
			
			let _ = Entry(title: title, bodyText: body)
		
		}
		
		do {
			try CoreDataStack.shared.mainContext.save()
			print("here")
			navigationController?.popViewController(animated: true)
		} catch {
			
			NSLog("Failed To Save: \(error)")
		}
		
		
	}
	
	@IBOutlet var titleTextField: UITextField!
	@IBOutlet var bodyTextView: UITextView!
	var entry: Entry? { didSet { updateViews() } }
}
