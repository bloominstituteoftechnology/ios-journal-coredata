//
//  EntryDetailVC.swift
//  Journal Core Data
//
//  Created by Seschwan on 7/10/19.
//  Copyright © 2019 Seschwan. All rights reserved.
//

import UIKit

class EntryDetailVC: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var notesTextView:  UITextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        borderUpdate()

    }
    

    private func borderUpdate() {
        let borderWidth: CGFloat  = 1
        let borderRadius: CGFloat = 5
        let borderColor = UIColor.lightGray.cgColor
        
        titleTextField.layer.borderColor = borderColor
        notesTextView.layer.borderColor  = borderColor
        
        titleTextField.layer.borderWidth = borderWidth
        notesTextView.layer.borderWidth  = borderWidth
        
        titleTextField.layer.cornerRadius = borderRadius
        notesTextView.layer.cornerRadius  = borderRadius
        
    }
    
    // MARK: - Actions and Methods
    
    @IBAction func saveBtnPressed(_ sender: UIBarButtonItem) {
        
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
