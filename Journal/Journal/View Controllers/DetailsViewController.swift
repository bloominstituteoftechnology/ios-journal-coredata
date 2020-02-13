//
//  DetailsViewController.swift
//  Journal
//
//  Created by Sal Amer on 2/12/20.
//  Copyright © 2020 Sal Amer. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    //MARK - Outlets
    @IBOutlet weak var titleEntryLbl: UITextField!
    @IBOutlet weak var descriptionLbl: UITextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    // MARK - Actions
    
    @IBAction func saveBtnPressed(_ sender: UIBarButtonItem) {
    }
    

}

