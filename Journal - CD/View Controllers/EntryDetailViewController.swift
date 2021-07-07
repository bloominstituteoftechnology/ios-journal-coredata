//
//  EntryDetailViewController.swift
//  Journal - CD
//
//  Created by Angelique Abacajan on 12/16/19.
//  Copyright © 2019 Angelique Abacajan. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var moodSegmentedControl: UISegmentedControl!
    
    
    // MARK: - Properties
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    // MARK: - Setup
    private func updateViews() {
        guard isViewLoaded else { return }
        
        moodSegmentedControl.layer.cornerRadius = 4
        moodSegmentedControl.layer.cornerCurve = .continuous
        moodSegmentedControl.layer.borderWidth = 1
        moodSegmentedControl.layer.borderColor = UIColor(displayP3Red: 207/255, green: 207/255, blue: 207/255, alpha: 1.0).cgColor
        
        textView.layer.cornerRadius = 4
        textView.layer.cornerCurve = .continuous
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor(displayP3Red: 207/255, green: 207/255, blue: 207/255, alpha: 1.0).cgColor
        
    }
}
