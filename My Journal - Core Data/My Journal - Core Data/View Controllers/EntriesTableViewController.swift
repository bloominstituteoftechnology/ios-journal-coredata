//
//  EntriesTableViewController.swift
//  My Journal - Core Data
//
//  Created by Nick Nguyen on 2/24/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import UIKit
import CoreData

class EntriesTableViewController: UITableViewController
{

    private let entryController = EntryController()
    
    lazy var fetchedResultsController : NSFetchedResultsController<Entry> = {
        let fetchRequest : NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: #keyPath(Entry.mood), ascending: true),
            NSSortDescriptor(key:#keyPath(Entry.timestamp), ascending: true)
        ]
        
        let context = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: #keyPath(Entry.mood), cacheName: nil)
        frc.delegate = self
        try? frc.performFetch()
        return frc
        
    }()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table View Data Source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Helper.cellID, for: indexPath) as? EntryTableViewCell else { return UITableViewCell()}
        cell.entry = fetchedResultsController.object(at: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
// MARK: - Size and Color for header
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
      
        guard  let header = view as? UITableViewHeaderFooterView else { return }
        header.contentView.backgroundColor = (section % 2 == 0 ) ? #colorLiteral(red: 0.5790472627, green: 0.9850887656, blue: 0.8092169166, alpha: 1) : UIColor.yellow
        header.contentView.alpha = 0.8
        if let textlabel = header.textLabel {
            textlabel.font = textlabel.font.withSize(38)
            textlabel.textAlignment = .center
        
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionInfo = fetchedResultsController.sections?[section] else { return nil }
      
        return sectionInfo.name.capitalized
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let entry = fetchedResultsController.object(at: indexPath)
            CoreDataStack.shared.mainContext.delete(entry)
            do {
                try CoreDataStack.shared.mainContext.save()
            } catch let error as NSError {
                CoreDataStack.shared.mainContext.reset()
                print(error.localizedDescription)
            }
          
        }
    }
 
// MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
            case Helper.addSegue:
                guard let destVC = segue.destination as? EntryDetailViewController else { return }
                destVC.entryController = entryController
            case Helper.cellSegue:
                guard let destVC = segue.destination as? EntryDetailViewController else { return }
                
                if let index = tableView.indexPathForSelectedRow {
                    destVC.entry = fetchedResultsController.object(at: index)
                    destVC.entryController = entryController
            }
            
                
            default:
            break
        }
    }
}
// MARK: - NSFetchedResultsControllerDelegate

extension EntriesTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
            case .insert:
                tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
            case .delete:
                tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
            default:
                break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
            case .insert:
                guard let newIndexPath = newIndexPath else { return }
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            case .update:
                guard let indexPath = indexPath else { return }
                tableView.reloadRows(at: [indexPath], with: .automatic)
            case .move:
                guard let oldIndexPath = indexPath,
                    let newIndexPath = newIndexPath else { return }
                tableView.deleteRows(at: [oldIndexPath], with: .automatic)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            case .delete:
                guard let indexPath = indexPath else { return }
                tableView.deleteRows(at: [indexPath], with: .automatic)
            @unknown default:
                break
        }
    }
    
    
}
