//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Chad Parker on 4/25/20.
//  Copyright © 2020 Chad Parker. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    var entry: Entry? {
        didSet {
            print(entry ?? "")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
