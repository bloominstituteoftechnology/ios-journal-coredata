//
//  CreateEntryViewController.swift
//  Journal (Core Data)
//
//  Created by Simon Elhoej Steinmejer on 14/08/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController
{
    var entry: Entry?
    {
        didSet
        {
            updateViews()
        }
    }
    var entryController: EntryController?
    
    
    let titleTextField: UITextField =
    {
        let tf = UITextField()
        tf.placeholder = "Title"
        tf.borderStyle = .roundedRect
        tf.backgroundColor = .white
        
        return tf
    }()
    
    let noteTextView: UITextView =
    {
        let tv = UITextView()
        tv.isEditable = true
        tv.backgroundColor = .white
        tv.layer.cornerRadius = 6
        tv.layer.masksToBounds = true
        
        return tv
    }()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        setupUI()
        setupNavBar()
        updateViews()
    }
    
    private func updateViews()
    {
        if let entry = entry
        {
            title = entry.title
            titleTextField.text = entry.title
            noteTextView.text = entry.note
        }
        else
        {
            title = "Create Entry"
        }
    }
    
    private func setupNavBar()
    {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(handleSave))
    }
    
    @objc private func handleSave()
    {
        guard let title = titleTextField.text, !title.isEmpty else { return }
        
        if let entry = entry
        {
            entryController?.updateEntry(on: entry, with: title, note: noteTextView.text)
        }
        else
        {
            let _ = Entry(title: title, note: noteTextView.text)
            entryController?.saveToPersistence()
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    private func setupUI()
    {
        view.addSubview(titleTextField)
        view.addSubview(noteTextView)
        
        titleTextField.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingRight: 8, paddingBottom: 0, width: 0, height: 30)
        
        noteTextView.anchor(top: titleTextField.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingRight: 8, paddingBottom: -80, width: 0, height: 0)
    }
    
}
















