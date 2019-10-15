//
//  DetailViewController.swift
//  Journal
//
//  Created by Jesse Ruiz on 10/14/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var gradientLayer: CAGradientLayer!
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    var entryController: EntryController?
        
    
    // MARK: - Outlets
    @IBOutlet weak var entryTitle: UITextField!
    @IBOutlet weak var entryText: UITextView!
    @IBOutlet weak var moodSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        createGradientLayer()
    }
    
    // MARK: - Actions
    @IBAction func save(_ sender: UIBarButtonItem) {
        if let title = entryTitle.text,
            let bodyText = entryText.text {
            
            if let entry = entry {
                entryController?.updateEntry(entry: entry, with: title, bodyText: bodyText)
            } else {
                entryController?.createEntry(with: title, bodyText: bodyText, context: CoreDataStack.shared.mainContext)
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    func updateViews() {
        guard isViewLoaded else { return }
        
        title = entry?.title ?? "Create Entry"
        entryTitle.text = entry?.title
        entryText.text = entry?.bodyText
    }
    
    func createGradientLayer() {

        let color1 = UIColor.systemTeal.cgColor
        let color2 = UIColor.systemBlue.cgColor
        let lightTeal = color1.copy(alpha: 0.5)
        let lightBlue = color2.copy(alpha: 0.7)

        gradientLayer = CAGradientLayer()

        gradientLayer.frame = self.view.bounds

        gradientLayer.colors = [lightTeal!, lightBlue!]

        self.view.layer.addSublayer(gradientLayer)

        gradientLayer.locations = [0.0, 1.0]
    }
}
