//
//  EntriesTableViewController.swift
//  JournalCoreData
//
//  Created by Nelson Gonzalez on 2/11/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import UIKit

class EntriesTableViewController: UITableViewController {
    
    var entryController = EntryController()

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return entryController.entries.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath) as! EntryTableViewCell

        

        return cell
    }
   

   
   
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
   

    // MARK: - Navigation

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    

}
