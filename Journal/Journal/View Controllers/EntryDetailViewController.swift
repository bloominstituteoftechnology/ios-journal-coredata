//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Michael Stoffer on 7/10/19.
//  Copyright © 2019 Michael Stoffer. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    // MARK: - IBOutlets and Properties
    @IBOutlet var saveButton: UIBarButtonItem!
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var bodyTextView: UITextView!
    
//    var entry: Entry? {
//        didSet {
//            self.updateViews()
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.updateViews()
        self.toggleSaveButton()
        self.titleTextField.addTarget(self, action: #selector(toggleSaveButton), for: .editingChanged)
    }
    
    // MARK: - IBActions and Methods
    @IBAction func saveButtonTapped(_ sender: Any) {
    }
    
//    private func updateViews() {
//        guard isViewLoaded else { return }
//
//        self.title = self.entry?.title ?? "Create Entry"
//        self.titleTextField.text = entry?.title
//        self.bodyTextView.text = entry?.body
//    }
    
    @objc private func toggleSaveButton() {
        self.saveButton.isEnabled = !self.titleTextField.text!.isEmpty
    }
}
