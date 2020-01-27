//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Ufuk Türközü on 27.01.20.
//  Copyright © 2020 Ufuk Türközü. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

// MARK: - Outlets
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var bodyTV: UITextView!
// MARK: - Properties
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    var entryController = EntryController()
// MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        // Do any additional setup after loading the view.
    }
    @IBAction func save(_ sender: Any) {
        guard let title = titleTF.text, let bodyText = bodyTV.text, !title.isEmpty else { return }
        
        if let entry = entry {
            entryController.updateEntry(entry: entry, with: title, timestamp: entry.timestamp ?? Date(), bodyText: bodyText, identifier: entry.identifier ?? "")
        } else {
            entryController.createEntry(with: title, timestamp: Date(), bodyText: bodyText, identifier: "")
        }
        navigationController?.popViewController(animated: true)
        
    }
    
    private func updateViews() {
        guard isViewLoaded else { return }
        title = entry?.title ?? "Create Entry"
        titleTF.text = entry?.title
        bodyTV.text = entry?.bodyText
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
