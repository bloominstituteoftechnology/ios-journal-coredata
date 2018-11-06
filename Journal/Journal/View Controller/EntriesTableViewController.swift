import UIKit

class EntriesTableViewController: UITableViewController {
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
    // MARK: - Table view data source
    
    let entryController = EntryController()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return entryController.entries.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EntryTableViewCell
        let entry = entryController.entries[indexPath.row]
        cell.entry = entry
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let entry = entryController.entries[indexPath.row]
            let moc = CoreDataStack.shared.mainContext
            moc.delete(entry)
            
            do {
                try moc.save()
                tableView.reloadData()
            } catch {
                moc.reset()
            }
        }
    }
    
    // MARK: - Navigation
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailVC = segue.destination as! EntryDetailViewController
        if segue.identifier == "ShowDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                detailVC.entry = entryController.entries[indexPath.row]
                detailVC.entryController = entryController
            }
        } else if segue.identifier == "AddSegue" {
            detailVC.entryController = entryController
        }
    }
    
}
