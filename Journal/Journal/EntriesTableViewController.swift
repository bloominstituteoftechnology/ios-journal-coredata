//
//  EntriesTableViewController.swift
//  Journal
//
//  Created by David Williams on 4/21/20.
//  Copyright © 2020 david williams. All rights reserved.
//

import UIKit
import CoreData

class EntriesTableViewController: UITableViewController {
    
    var  ce = EntryTableViewCell()
    
    var entries: [Entry] {
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        let context = CoreDataStack.shared.mainContext
        
        do {
            let fetchedTasks = try context.fetch(fetchRequest)
            
            return fetchedTasks
        } catch {
            NSLog("Error fetching tasks: \(error)")
            return []
        }
    }
   
    
    var dateFormatter: DateFormatter =  {
                      let formatter = DateFormatter()
                      formatter.dateFormat = "MM-dd-yyyy HH:mm"
                      formatter.timeZone = TimeZone(secondsFromGMT: 0)
                      return formatter
                  }()
                  
                  func string(from date: Date) -> String {
                         return dateFormatter.string(from: date)
                     }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       print(entries)
        return entries.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as? EntryTableViewCell else { return UITableViewCell() }

        let entry = entries[indexPath.row]
        
        cell.entry = entry

        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
                     let entry = entries[indexPath.row]
                     let context = CoreDataStack.shared.mainContext
                     
                     context.delete(entry)
                     
                     do {
                         try context.save()
                     } catch {
                         NSLog("Error saviing context after deleting Entry: \(error)")
                         context.reset()
                     }
                     tableView.deleteRows(at: [indexPath], with: .fade)
                 }    }
    

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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowEntry" {
          //  if let detailVC = segue.destination as? ShowJournalDetailViewController
        }
        // work on detail vc after tappinig on cell
    }
}
