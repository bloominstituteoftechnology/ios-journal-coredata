//
//  EntriesTableViewController.swift
//  Journal
//
//  Created by Eoin Lavery on 06/08/2020.
//  Copyright © 2020 Eoin Lavery. All rights reserved.
//

import UIKit
import CoreData

class EntriesTableViewController: UITableViewController {
    
    //MARK: - IBOUTLETS
    @IBOutlet weak var addEntryButton: UIBarButtonItem!
    
    //MARK: - PROPERTIES
    var entries: [Entry] {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let context = CoreDataStack.shared.mainContext
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            NSLog("Error fetching Entries from MangedObjectContext")
            return []
        }
    }
    
    //MARK: - VIEW LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        addEntryButton.image = UIImage(systemName: "plus.square")
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        tableView.reloadData()
    }

    // MARK: - UITABLEVIEW DATA SOURCE
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EntryTableViewCell.reuseIdentifier, for: indexPath) as? EntryTableViewCell else {fatalError("Can't dequeue reusable cell of type \(EntryTableViewCell.reuseIdentifier)")}

        cell.entry = entries[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let entry = entries[indexPath.row]
            let moc = CoreDataStack.shared.mainContext
            moc.delete(entry)
            
            do {
                try moc.save()
                tableView.reloadData()
            } catch {
                moc.reset()
                NSLog("Error deleting Entry from MangedObjectContext: \(error)")
            }
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
