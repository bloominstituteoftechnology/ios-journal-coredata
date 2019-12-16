//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Chad Rutherford on 12/16/19.
//  Copyright © 2019 Chad Rutherford. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    let titleTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Enter a title:"
        return tf
    }()
    
    let bodyTextView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.text = ""
        return tv
    }()
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    var entryController: EntryController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(handleSaveTapped))
        updateViews()
    }
    
    private func setupSubviews() {
        view.backgroundColor = .opaqueSeparator
        view.addSubview(titleTextField)
        view.addSubview(bodyTextView)
        NSLayoutConstraint.activate([
            titleTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            bodyTextView.leadingAnchor.constraint(equalTo: titleTextField.leadingAnchor),
            bodyTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 8),
            bodyTextView.trailingAnchor.constraint(equalTo: titleTextField.trailingAnchor),
            bodyTextView.bottomAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func updateViews() {
        title = entry?.title ?? "Create Entry"
        guard let entry = entry, self.isViewLoaded else { return }
        titleTextField.text = entry.title
        bodyTextView.text = entry.bodyText
    }
    
    @objc private func handleSaveTapped() {
        guard let title = titleTextField.text, !title.isEmpty, let bodyText = bodyTextView.text, !bodyText.isEmpty else { return }
        if let entry = entry {
            entryController?.update(entry: entry, title: title, bodyText: bodyText)
            navigationController?.popViewController(animated: true)
        } else {
            entryController?.createEntry(title: title, bodyText: bodyText)
            navigationController?.popViewController(animated: true)
        }
    }
}
