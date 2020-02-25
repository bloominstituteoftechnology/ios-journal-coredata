//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Ufuk Türközü on 24.02.20.
//  Copyright © 2020 Ufuk Türközü. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var bodyTV: UITextView!

    // MARK: - Properties
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    var entryController = EntryController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if entry == nil {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
        }
    }
    
    @objc func save() {
        guard let title = titleTF.text, let bodyText = bodyTV.text, !title.isEmpty else { return }
        
        if let entry = entry {
            entryController.update(entry: entry, with: title, timestamp: entry.timestamp ?? Date(), bodyText: bodyText)

        } else {
            entryController.create(with: title, timestamp: Date(), bodyText: bodyText, id: "")
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
