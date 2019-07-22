//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Kat Milton on 7/22/19.
//  Copyright © 2019 Kat Milton. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var bodyTextView: UITextView!
    @IBOutlet var saveButton: UIBarButtonItem!

    
    var entry: Entry? {
        didSet {
            self.updateViews()
        }
    }
    var entryController: EntryController?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
        bodyTextView.delegate = self
        titleTextField.delegate = self
        updateViews()
        setupKeyboardDismissRecognizer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        updateViews()
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        guard let title = titleTextField.text,
            let bodyText = bodyTextView.text,
            !title.isEmpty else {
                let alert = UIAlertController(title: "No Title!", message: "Please add a title to your entry", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return }
        
        if let entry = entry {
            let alert = UIAlertController(title: "Editing Entry", message: "Are you sure you want to overwrite your entry?", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Save", style: UIAlertAction.Style.destructive, handler: { UIAlertAction in
                self.entryController?.updateEntry(entry: entry, title: title, bodyText: bodyText)
                self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
            
            
        } else {
            self.entryController?.createEntry(title: title, bodyText: bodyText)
        }
        
        navigationController?.popViewController(animated: true)
        
    }

    func setAppearance() {
        view.backgroundColor = AppearanceHelper.whiteBackground
        titleTextField.backgroundColor = AppearanceHelper.whiteBackground
        bodyTextView.backgroundColor = AppearanceHelper.whiteBackground
    }
    
    func updateViews() {
        
        guard isViewLoaded else { return }
        
        setAppearance()
        if entry?.title == nil {
            title = "Create Entry"
            saveButton.tintColor = AppearanceHelper.highlightColor.withAlphaComponent(0.1)
        } else {
            title = nil
            saveButton.title = "Edit"
        }
        
        
        titleTextField.text = entry?.title
        let placeHolder = "Enter your text"
        bodyTextView.text = entry?.bodyText ?? placeHolder
        if bodyTextView.text == placeHolder {
            bodyTextView.textColor = UIColor.lightGray
        } else {
            bodyTextView.textColor = UIColor.black
        }
        
    }
    
    func setupKeyboardDismissRecognizer(){
        let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(EntryDetailViewController.dismissKeyboard))
        
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    

}


extension EntryDetailViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter your text"
            textView.textColor = UIColor.lightGray
        }
    }
    
}

extension EntryDetailViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "" {
            self.saveButton.tintColor = AppearanceHelper.highlightColor.withAlphaComponent(0.2)
            self.saveButton.isEnabled = false
        } else {
            
            UIView.animate(withDuration: 0.8, delay: 1.0, options: .curveEaseIn, animations: {
                self.saveButton.tintColor = AppearanceHelper.highlightColor.withAlphaComponent(1.0)
                self.saveButton.isEnabled = true
            }, completion: nil)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if reason == .committed {
            if textField.text == "" {
                self.saveButton.tintColor = AppearanceHelper.highlightColor.withAlphaComponent(0.2)
                self.saveButton.isEnabled = false
            } else {
                
                UIView.animate(withDuration: 0.8, delay: 1.0, options: .curveEaseIn, animations: {
                    self.saveButton.tintColor = AppearanceHelper.highlightColor.withAlphaComponent(1.0)
                    self.saveButton.isEnabled = true
                }, completion: nil)
            }
        }
    }
    
    
}
