//
//  EntryDetailViewController.swift
//  Journal (Core Data)
//
//  Created by Julian A. Fordyce on 2/18/19.
//  Copyright © 2019 Glas Labs. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        designButton()
    }
    
    @IBAction func saveEntry(_ sender: Any) {
    }
    
    func designButton() {
        saveButton.layer.cornerRadius = saveButton.frame.width / 2
        saveButton.backgroundColor = UIColor.gray
        
        saveButton.layer.shadowOffset = CGSize.zero
        saveButton.layer.shadowColor = UIColor.black.cgColor
        saveButton.layer.shadowOpacity = 1
        
        saveButton.setTitleColor(.white, for: .normal)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - Properties
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var entryTextField: UITextView!
    @IBOutlet weak var saveButton: UIButton!
}
