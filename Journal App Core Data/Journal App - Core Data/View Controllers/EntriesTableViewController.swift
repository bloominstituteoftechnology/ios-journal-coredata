
import UIKit
import CoreData

class EntriesTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    let entryController = EntryController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.8450079077, green: 0.9921568627, blue: 0.9735982676, alpha: 1)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
        
    }
    
    // The value of this property will be the result of executing this closure:
    lazy var fetchedResultsController: NSFetchedResultsController<Entry> = {
        // Fetch request from Entry object
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        // Sort descriptor sorts entries based on timestamp
        // Give sort descriptor to fetch request's sortDescriptor's property (an array of sort descriptors)
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "timestamp", ascending: true)
        ]
        
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: moc,
                                             sectionNameKeyPath: "mood",
                                             cacheName: nil)
        
        // Adopt the NSFetchedResultsControllerDelegate protocol
        frc.delegate = self
        
        // Perform the fetch request
        try? frc.performFetch()
        
        return frc
        
        
    }()

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EntryTableViewCell.reuseIdentifier, for: indexPath) as? EntryTableViewCell else {
            fatalError("Could not dequeue cell")
        }

        // Pass an Entry to the cell's entry property in order for it to call the updateViews() method to fill in the information for the cell's labels
        cell.entry = fetchedResultsController.object(at: indexPath)
        //cell.entry = entryController.entries[indexPath.row]

        return cell
    }
    

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let entry = fetchedResultsController.object(at: indexPath)
            //let entry = entryController.entries[indexPath.row]
            
            // Delete the row from the data source
            entryController.deleteEntry(entry: entry)
            //tableView.deleteRows(at: [indexPath], with: .fade)
        
            
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return fetchedResultsController.sections?[section].name
    }




    // MARK: - Navigation


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Create entry - pass empty detail view controller
        guard let destination = segue.destination as? EntryDetailViewController else { return }
        
        destination.entryController = entryController
        
        // Get the new view controller using segue.destination.
        if segue.identifier == "ViewEntry" {
            // the user tapped on a cell
            let destination = segue.destination as! EntryDetailViewController
            // get the tapped row (it's optional)
            if let tappedRow = tableView.indexPathForSelectedRow {
                // Pass the entryController and the Entry that correspond to the tapped row
                destination.entry = fetchedResultsController.object(at: tappedRow)
                //destination.entry = entryController.entries[tappedRow.row]
            }
        }
        
        // Don't need to handle the CreateEntry segue because we want it to show a blank Detail View Controller
        
    }
    
    // MARK: - NSFetchedResultsControllerDelegate Methods
    
    // React to when we hear about changes
    
    // Controller tells us something is about to change
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    // Get the fetched results change type
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            guard let indexPath = newIndexPath else { return }
            // tell the table view to insert rows at this index path
            tableView.insertRows(at: [indexPath], with: .automatic)
        case .delete:
            // Make sure we have an index path
            guard let indexPath = indexPath else { return }
            // delete the row at that index path
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath else { return }
            guard let newIndexPath = newIndexPath else { return }
            tableView.moveRow(at: oldIndexPath, to: newIndexPath)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default: break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    

    



}
