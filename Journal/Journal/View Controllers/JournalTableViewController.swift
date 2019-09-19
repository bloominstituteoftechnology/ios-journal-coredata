//
//  JournalTableViewController.swift
//  Journal
//
//  Created by Alex Rhodes on 9/16/19.
//  Copyright © 2019 Alex Rhodes. All rights reserved.
//

import UIKit
import CoreData

class JournalTableViewController: UITableViewController {
    
    let journalController = JournalController()
    
    var journals: [Journal] {
        let request: NSFetchRequest<Journal> = Journal.fetchRequest()
        
        do {
            let tasks = try CoreDataStack.shared.mainContext.fetch(request)
            return tasks
        } catch {
            NSLog("Error fetching tasks: \(error)")
            return []
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return journals.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JournalCell", for: indexPath)

        cell.textLabel?.text = journals[indexPath.row].title
        
        let formatter = DateFormatter()
        let date = journals[indexPath.row].time
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let string = formatter.string(from: date ?? Date())
        cell.detailTextLabel?.text = string

        return cell
    }
   

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let journal = journals[indexPath.row]
            journalController.delete(journal: journal)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "JournalDetailSegue" {
            guard let detailVC = segue.destination as? JournalDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow else { return }
            
            detailVC.journal = journals[indexPath.row]
            detailVC.journalController = journalController
        } else if segue.identifier == "CreateJournalSegue" {
            guard let detailVC = segue.destination as? JournalDetailViewController else { return }
            
            detailVC.journalController = journalController
        }
      
    }

}
