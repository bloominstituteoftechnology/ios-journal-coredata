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
    @IBOutlet weak var moodSC: UISegmentedControl!
    @IBOutlet weak var bodyTV: UITextView!

    // MARK: - Properties
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    var entryController: EntryController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        // Do any additional setup after loading the view.
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        if let entry = entry {
//            title = entry.title
//            titleTF.text = entry.title
//            bodyTV.text = entry.bodyText
//        } else {
//            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
//        }
//    }
    
    @IBAction func saveTapped(_ sender: Any) {
        guard let title = titleTF.text, let bodyText = bodyTV.text, !title.isEmpty else { return }
        
        let mood = EntryMood.allCases[moodSC.selectedSegmentIndex]
        
        if let entry = entry {
            entryController?.update(entry: entry, with: title, timestamp: entry.timestamp ?? Date(), bodyText: bodyText, mood: mood)

        } else {
            entryController?.create(with: title, timestamp: Date(), bodyText: bodyText, mood: mood, id: "")
        }
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    private func updateViews() {
        guard isViewLoaded else { return }
        title = entry?.title ?? "Create Entry"
        titleTF.text = entry?.title
        bodyTV.text = entry?.bodyText
        
        if let entryMood = entry?.mood,
            let mood = EntryMood(rawValue: entryMood) {
            moodSC.selectedSegmentIndex = EntryMood.allCases.firstIndex(of: mood) ?? 2
        }
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
