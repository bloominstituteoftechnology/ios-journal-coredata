//
//  EntiresTableViewController.swift
//  Journal
//
//  Created by Sal Amer on 2/12/20.
//  Copyright © 2020 Sal Amer. All rights reserved.
//

import UIKit

class EntiresTableViewController: UITableViewController {
    
    let entryController = EntryController()
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return entryController.entries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "JournalCell", for: indexPath) as? EntryTableViewCell else { return UITableViewCell() }
        
       let entry = entryController.entries[indexPath.row]
        
        //how to automatically populate using custom cell?
        cell.titleLabel.text = entry.title
        cell.descriptionLbl.text = entry.bodytext
        cell.dateTimeLbl.text = "\(dateFormatter.string(from: entry.timestamp!))"
        return cell
    }
 

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let entry = entryController.entries[indexPath.row]
            let moc = CoreDataStack.shared.mainContext
            moc.delete(entry)
            
            do {
                try moc.save()
            } catch {
                moc.reset()
                print("Error saving deleted task: \(error)")
            }
            tableView.reloadData()
    }
   }

     
 
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowJournalDetailSegue" {
            guard let detailVC = segue.destination as? EntryDetailViewController else { return }
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            detailVC.entry = entryController.entries[indexPath.row]
        } else if segue.identifier == "CreateJournalEntrySegue" {
            if let detailVC = segue.destination as? EntryDetailViewController {
                detailVC.entryController = entryController
            }
        }
    }
 

}
