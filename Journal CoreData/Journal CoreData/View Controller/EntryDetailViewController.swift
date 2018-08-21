//
//  EntryDetailViewController.swift
//  Journal CoreData
//
//  Created by Ngozi Ojukwu on 8/20/18.
//  Copyright © 2018 iyin. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        updateView()
    }

    
    @IBAction func Save(_ sender: Any) {
        guard let name = nameTextField.text,
            !name.isEmpty,
            let bodyText = bodytextView.text else { return }
        if let entry = entry {
            entryController?.updateEntry(entry: entry, name: name, bodyText: bodyText)
        } else {
            entryController?.createEntry(name: name, bodyText: bodyText)
        }
        navigationController?.popViewController(animated: true)
    }
    
    
    func updateView(){
        if isViewLoaded{
            
            title = entry?.name ?? "Create Entry"
            nameTextField.text = entry?.name
            bodytextView.text = entry?.bodyText
        }
    }
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var bodytextView: UITextView!
    
    var entry: Entry?{
        didSet{
            updateView()
        }
    }
    var entryController: EntryController?
    

}
