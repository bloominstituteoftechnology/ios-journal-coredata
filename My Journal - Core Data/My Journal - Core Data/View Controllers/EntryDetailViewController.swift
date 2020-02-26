//
//  ViewController.swift
//  My Journal - Core Data
//
//  Created by Nick Nguyen on 2/24/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import UIKit


 enum MoodCase : String,CaseIterable {
    case low = "🙀"
    case medium = "😸"
    case high = "😿"
}

class EntryDetailViewController: UIViewController
{

    
    
    // MARK: - Properties
    
     var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    var entryController: EntryController?
    private var mood = "🙀"
    
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
        textView.font = UIFont.systemFont(ofSize: 20)
        textView.textColor = .white
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.autocapitalizationType = .sentences
        textView.backgroundColor = #colorLiteral(red: 0.697096169, green: 0.5818155408, blue: 0.7320093513, alpha: 1)
        textView.alpha = 0.6
        textView.layer.cornerRadius = 20
        return textView
    }()
    
    private var segmentControl: UISegmentedControl = {
        let emojis = ["🙀","😸","😿"]
        let sc = UISegmentedControl(items: emojis)
        sc.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 30) ], for: .normal)
        sc.selectedSegmentIndex = 0
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.selectedSegmentTintColor = #colorLiteral(red: 0.697096169, green: 0.5818155408, blue: 0.7320093513, alpha: 1)
        sc.addTarget(self, action: #selector(handleSegment), for: .valueChanged)
        return sc
    }()
    
    @objc private func handleSegment(_ segmentControl: UISegmentedControl) {
       
        switch segmentControl.selectedSegmentIndex {
            case 0:
                mood =  MoodCase.low.rawValue
            case 1:
                mood =  MoodCase.medium.rawValue
            case 2:
                mood =  MoodCase.high.rawValue
            default:
                break
        }
    }
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
            entryController?.updateEntry(with: title, bodyText: bodyText, mood: mood, identifier: UUID(), entry: entry)
        } else {
            entryController?.create(title: title, bodyText: bodyText, identifier: UUID(), mood: mood, date: Date())
        }
        navigationController?.popViewController(animated: true)
    }
    
    private func updateViews() {
    
        if let entry = entry {
            entryTextField.text = entry.title
            entryTextView.text = entry.bodyText
            guard let currentMood = entry.mood else { return }
            segmentControl.selectedSegmentIndex = MoodCase.allCases.firstIndex(of: MoodCase(rawValue:currentMood) ?? MoodCase.low ) ?? 1
            title = entry.title
            
        } else {
            title = "Create Entry"
        }

             
    }
    
    private func setUpSubviews() {
        view.addSubview(entryTextField)
        view.addSubview(entryTextView)
        view.addSubview(segmentControl)
    }
    
 // MARK: - Constraint everything
    
    private func layoutSubviews() {
        NSLayoutConstraint.activate([
            entryTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            entryTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            entryTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 50),
            entryTextField.heightAnchor.constraint(equalToConstant: 50),
        
            entryTextView.leadingAnchor.constraint(equalTo: entryTextField.leadingAnchor),
            entryTextView.trailingAnchor.constraint(equalTo: entryTextField.trailingAnchor),
            entryTextView.topAnchor.constraint(equalTo: entryTextField.bottomAnchor, constant: 32),
            entryTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32),
            
            segmentControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            segmentControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            segmentControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            segmentControl.heightAnchor.constraint(equalToConstant: 40)
            
        ])
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

