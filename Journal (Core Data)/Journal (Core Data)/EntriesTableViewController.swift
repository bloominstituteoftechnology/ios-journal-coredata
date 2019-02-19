//
//  EntriesTableViewController.swift
//  Journal (Core Data)
//
//  Created by Julian A. Fordyce on 2/18/19.
//  Copyright © 2019 Glas Labs. All rights reserved.
//

import UIKit

class EntriesTableViewController: UITableViewController {

    let entryController = EntryController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }
    
    @IBAction func add(_ sender: Any) {
    }
    
    
    // MARK: - Table view data source



    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        return entryController.entries.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as? EntryTableViewCell else { fatalError("Unable to dequeue cell") }
       
            cell.entry = entryController.entries[indexPath.row]
        
        return cell
    }
  


    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
   

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cell" {
            let detailVC = segue.destination as! EntryDetailViewController
            if let tappedRow = tableView.indexPathForSelectedRow {
                detailVC.entry = entryController.entries[tappedRow.row]
            } 
        }
    }
 
    
    // MARK: - Properties
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
}
