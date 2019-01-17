//
//  JournalTableViewController.swift
//  CoreDataJournal
//
//  Created by Benjamin Hakes on 1/14/19.
//  Copyright © 2019 Benjamin Hakes. All rights reserved.
//

import UIKit
import CoreData

class JournalTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "EntryTableViewCell", bundle: nil), forCellReuseIdentifier: "entryCell")
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController<Entry> = {
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "timestamp", ascending: true)
        ]
        
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: "mood", cacheName: nil)
        
        frc.delegate = self
        try? frc.performFetch()
        
        return frc
        
    }()
    
    @IBAction func filterByMood(_ sender: UISegmentedControl) {
        // the user tapped a segment to change the current mood
        let moodIndex = sender.selectedSegmentIndex
        if moodIndex < EntryMood.allCases.count {
            currentMood = EntryMood.allCases[moodIndex]
        } else {
            currentMood = nil
        }
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath) as? EntryTableViewCell else {fatalError("Unable to dequeue cell as EntryTableViewCell")}
        
        
        cell.titleLabel.text = fetchedResultsController.object(at: indexPath).title
        cell.subtitleLabel.text = fetchedResultsController.object(at: indexPath).bodyText
        
        guard let date = fetchedResultsController.object(at: indexPath).timestamp else { fatalError("cannot get date") }
        cell.idLabel.text = String.dateToString(date: date)
        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let entry = fetchedResultsController.object(at: indexPath)
            entryController.deleteEntry(entry: entry)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath) as? EntryTableViewCell else {fatalError("failed to dequeueReusableCell")}
        
        performSegue(withIdentifier: "viewEntryDetailSegue", sender: cell)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return fetchedResultsController.sections?[section].name
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let destVC = segue.destination as! DetailViewController
        
        if segue.identifier == "viewEntryDetailSegue" {
            
            if let tappedRow = tableView.indexPathForSelectedRow {
                print(tappedRow)
                let sectionObjects = fetchedResultsController.sections?[tappedRow.section]
                let entryToSend = sectionObjects?.objects?[tappedRow.row] as? Entry
                destVC.entry = entryToSend
            }
        }
        
        destVC.entryController = EntryController()
        
        
    }

    // MARK: - NSFetchedResultsControllerDelegate Methods
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
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
        }
    }
    
    // MARK: - Properties

    let entryController = EntryController()
    
    var currentMood: EntryMood? {
        didSet {
            if let mood = currentMood {
                let predicate = NSPredicate(format: "mood == %@", mood.rawValue)
                fetchedResultsController.fetchRequest.predicate = predicate
            } else {
                fetchedResultsController.fetchRequest.predicate = nil
            }
            try! fetchedResultsController.performFetch()
            tableView.reloadData()
        }
    }

}
