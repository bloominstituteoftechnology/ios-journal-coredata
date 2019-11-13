//
//  EntriesTableViewController.swift
//  Journal
//
//  Created by Jon Bash on 2019-11-11.
//  Copyright © 2019 Jon Bash. All rights reserved.
//

import UIKit

class EntriesTableViewController: UITableViewController {
    // MARK: - Properties
    
    var entryController = EntryController()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        entryController.delegate = self
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ViewEntryDetailSegue" {
            guard let detailVC = segue.destination as? EntryDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow
                else {
                    print("Error: failed to cast segue destination as EntryDetailViewController, or failed to get index path for selected row.")
                    return
            }
            detailVC.entry = entryController.fetch(entryAt: indexPath)
            detailVC.entryController = entryController
        } else if segue.identifier == "NewEntrySegue" {
            guard let addVC = segue.destination as? EntryDetailViewController
                else {
                    print("Error: failed to cast segue destination as EntryDetailViewController.")
                    return
            }
            addVC.entryController = entryController
        }
    }
}

// MARK: - Table Data Source

extension EntriesTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return entryController.numberOfMoods()
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return entryController.mood(forIndex: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as? EntryTableViewCell
            else {
                print("Cell cannot conform to EntryTableViewCell!")
                return UITableViewCell()
        }
        cell.entry = entryController.fetch(entryAt: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entryController.numberOfEntries(forIndex: section)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let entry = entryController.fetch(entryAt: indexPath) else {
                print("Could not find entry to delete!")
                return
            }
            entryController.delete(entry: entry)
        }
    }
}

// MARK: - Entry Controller Delegate

extension EntriesTableViewController: CoreDataStackDelegate {
    func entriesWillChange() {
        tableView?.beginUpdates()
    }
    
    func entriesDidChange() {
        tableView?.endUpdates()
    }
    
    func sectionChanged(atIndex sectionIndex: Int, with type: EntryController.ChangeType) {
        switch type {
        case .insert:
            tableView?.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tableView?.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            break
        }
    }
    
    func entryChanged(from indexPath: IndexPath?, to newIndexPath: IndexPath?, with type: EntryController.ChangeType) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView?.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView?.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath,
                let newIndexPath = newIndexPath else { return }
            tableView?.deleteRows(at: [oldIndexPath], with: .automatic)
            tableView?.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView?.deleteRows(at: [indexPath], with: .automatic)
        @unknown default:
            break
        }
    }
}
