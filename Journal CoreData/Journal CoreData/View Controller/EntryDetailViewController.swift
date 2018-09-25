//
//  EntryDetailViewController.swift
//  Journal CoreData
//
//  Created by Iyin Raphael on 9/24/18.
//  Copyright © 2018 Iyin Raphael. All rights reserved.
//

import UIKit 
import CoreData


class EntryDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    func updateViews(){
        if isViewLoaded {
            title =  entry?.title
            titleTextField.text = entry?.title
            textView.text = entry?.bodyText
        }
    }
    
    var entry: Entry?{
        didSet{
            updateViews()
        }
    }
    
    @IBAction func save(_ sender: Any) {
        guard let title = titleTextField.text,
        let bodyText = textView.text else {return}
        if let entry = entry{
            entry.title = title
            entry.bodyText = bodyText
        }else{
            let _ = Entry(title: title, bodyText: bodyText)
        }
        
        do{
            try moc.save()
        }catch{
            NSLog("Error saving Entry: \(error)")
        }
       navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var textView: UITextView!
    

}
