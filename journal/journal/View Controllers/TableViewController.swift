//  Copyright © 2019 Frulwinn. All rights reserved.

import UIKit

class TableViewController: UITableViewController {

    //MARK: - Properties
    let entryController = EntryController()
//    var entries: [Entry] {
//        return entryController.loadFromPersistentStore()
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entryController.entries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "journalCell", for: indexPath) as? TableViewCell else {fatalError("unable to dequeue tableview cell") }
        
        let entry = entryController.entries[indexPath.row]
        cell.entry = entry
        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let entry = entryController.entries[indexPath.row]
            let moc = CoreDataStack.shared.mainContext
            entryController.delete(entry: entry)
            
            do {
                try entryController.saveToPersistentStore()
            } catch {
                moc.reset()
                NSLog("error saving managed object context: \(error)")
            }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tableCellSegue" {
            
            if let destinationVC = segue.destination as? DetailViewController,
                let indexPath = tableView.indexPathForSelectedRow {
                
                let entry = entryController.entries[indexPath.row]
                
                destinationVC.entry = entry
            }
        }
    }
}
