//
//  EntryDetailViewController.swift
//  Journal2
//
//  Created by Carolyn Lea on 8/20/18.
//  Copyright © 2018 Carolyn Lea. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController
{
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    
    var entry: Entry?
    var entryController: EntryController?
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

    }

    @IBAction func saveEntry(_ sender: Any)
    {
        
    }
    
    
    
    

}
