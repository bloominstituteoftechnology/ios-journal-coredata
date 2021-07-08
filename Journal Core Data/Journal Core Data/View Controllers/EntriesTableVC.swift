//
//  ViewController.swift
//  Journal Core Data
//
//  Created by Seschwan on 7/10/19.
//  Copyright © 2019 Seschwan. All rights reserved.
//

import UIKit

class EntriesTableVC: UIViewController {
    
    // MARK: - Variables and Outlets
    @IBOutlet weak var tableView: UITableView!
    
    let entryController = EntryController()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate   = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem" {
            guard let destinationVC = segue.destination as? EntryDetailVC else { return }
            destinationVC.entryController = entryController
        }
        if segue.identifier == "ShowDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let entry = entryController.entries[indexPath.row]
            guard let destinationVC = segue.destination as? EntryDetailVC else { return }
            destinationVC.entryController = entryController
            destinationVC.entry = entry
        }
    }


}

extension EntriesTableVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entryController.entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? EntryTableViewCell else {
            return UITableViewCell()
        }
        
        let entry = entryController.entries[indexPath.row]
        
        cell.entry = entry
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let entry = entryController.entries[indexPath.row]
            entryController.delete(entry: entry)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
    
    
}

extension EntriesTableVC: UITableViewDelegate {
    
}

