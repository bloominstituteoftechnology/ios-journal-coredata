//
//  ViewController.swift
//  My Journal - Core Data
//
//  Created by Nick Nguyen on 2/24/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController
{

    
    
    // MARK: - Properties
    
     var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    var entryController: EntryController?
    
    
    private var entryTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter a title"
        textField.becomeFirstResponder()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .bezel
        return textField
    }()
    
    private var entryTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Type something here..."
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.autocapitalizationType = .words
        
        return textView
    }()
    
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        configureNavBar()
        setUpSubviews()
        layoutSubviews()
    }


    
    // MARK: - Methods
    
    private func configureNavBar() {
      
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveTapped))
    }
    
    @objc private func saveTapped() {
        guard let title = entryTextField.text, let bodyText = entryTextView.text else { return }
        
        if let entry = entry {
            entryController?.update(with: title, bodyText: bodyText, entry: entry)
        } else {
            entryController?.create(title: title, bodyText: bodyText, identifier: title, date: Date())
        }
        navigationController?.popViewController(animated: true)
    }
    
    private func updateViews() {
        if let entry = entry {
            entryTextField.text = entry.title
            entryTextView.text = entry.bodyText
            title = entry.title
        } else {
            title = "Create Entry"
        }

             
    }
    
    private func setUpSubviews() {
        view.addSubview(entryTextField)
        view.addSubview(entryTextView)
    }
    
 // MARK: - Constraint everything
    
    private func layoutSubviews() {
        NSLayoutConstraint.activate([
            entryTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            entryTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            entryTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 16),
            entryTextField.heightAnchor.constraint(equalToConstant: 50),
        
            entryTextView.leadingAnchor.constraint(equalTo: entryTextField.leadingAnchor),
            entryTextView.trailingAnchor.constraint(equalTo: entryTextField.trailingAnchor),
            entryTextView.topAnchor.constraint(equalTo: entryTextField.bottomAnchor, constant: 32),
            entryTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32)
            
        ])
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

