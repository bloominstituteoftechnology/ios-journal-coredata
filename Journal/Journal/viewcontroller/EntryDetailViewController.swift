//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Vincent Hoang on 5/20/20.
//  Copyright © 2020 Vincent Hoang. All rights reserved.
//

import Foundation
import UIKit

class EntryDetailViewController: UIViewController {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var bodyLabel: UILabel!
    
    var entry: Entry?
    
    var wasEdited = false
    
    override func viewDidLoad() {
        updateViews()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    private func updateViews() {
        if let entry = entry {
            titleLabel.text = entry.title
            bodyLabel.text = entry.bodyText
            
            let df = DateFormatter()
            df.timeStyle = .short
            df.dateStyle = .short
            
            if let date = entry.timeStamp {
                dateLabel.text = df.string(from: date)
            }
        }
    }
    
}
