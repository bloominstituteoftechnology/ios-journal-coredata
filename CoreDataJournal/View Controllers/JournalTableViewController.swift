//
//  JournalTableViewController.swift
//  CoreDataJournal
//
//  Created by Austin Potts on 9/16/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
import CoreData

class JournalTableViewController: UITableViewController {

    let taskController = TaskController()
    
    var tasks: [Task] {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        do{
          let tasks =  try CoreDataStack.share.mainContext.fetch(fetchRequest)
            return tasks
        } catch {
            NSLog("Error fetching task: \(error)")
            return[]
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

  

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tasks.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JournalCell", for: indexPath)
        
        cell.textLabel?.text = tasks[indexPath.row].title

        

        return cell
    }
    

 

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let task = tasks[indexPath.row]
            
            //You must delete the task if cell is deleted
            taskController.delete(task: task)
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "JournalCellSegue"{
            guard let detailVC = segue.destination as? JournalDetailViewController,
            let indexPath = tableView.indexPathForSelectedRow else{return}
            
            detailVC.task = tasks[indexPath.row]
            detailVC.taskController = taskController
            
        } else if segue.identifier == "AddJournalSegue"{
            guard let detailVC = segue.destination as? JournalDetailViewController else {return}
            
            detailVC.taskController = taskController
        }
    }
    

}
