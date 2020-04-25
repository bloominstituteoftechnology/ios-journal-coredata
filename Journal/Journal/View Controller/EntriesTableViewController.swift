//
//  EntriesTableViewController.swift
//  Journal
//
//  Created by Claudia Contreras on 4/22/20.
//  Copyright © 2020 thecoderpilot. All rights reserved.
//

import UIKit
import CoreData

class EntriesTableViewController: UITableViewController {

    // MARK: - Properties
    var entries: [Entry] {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let context = CoreDataStack.shared.mainContext
        
        do {
            let fetchTasks = try context.fetch(fetchRequest)
            return fetchTasks
        } catch {
            NSLog("Error fetching tasks: \(error)")
            return []
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "journalTitleCell", for: indexPath) as? EntryTableViewCell else { return UITableViewCell() }

        let entry = entries[indexPath.row]
        cell.titleLabel.text = entry.title
        cell.excerptLabel.text = entry.bodyText
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .short
        cell.dateAndTimeLabel.text = "\(dateFormatter.string(from: entry.timestamp ?? Date() ))"
        return cell
    }

    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let entry = entries[indexPath.row]
            let context = CoreDataStack.shared.mainContext
            
            context.delete(entry)
            
            do {
                try context.save()
            } catch {
                NSLog("Error saving context after deleting Task: \(error)")
                context.reset()
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }


    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
