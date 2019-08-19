//
//  EnteryDetailViewController.swift
//  Journal
//
//  Created by Taylor Lyles on 8/19/19.
//  Copyright © 2019 Taylor Lyles. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
	
	var entry: Entry?
	var entryController: EntryController?

	@IBOutlet weak var enteryTextField: UITextField!
	@IBOutlet weak var enteriesTextView: UITextView!
	
	
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
