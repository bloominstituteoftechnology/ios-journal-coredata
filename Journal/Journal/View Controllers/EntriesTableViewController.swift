//
//  EntriesTableViewController.swift
//  Journal
//
//  Created by Jordan Christensen on 9/17/19.
//  Copyright © 2019 Mazjap Co Technologies. All rights reserved.
//

import UIKit

class EntriesTableViewController: UITableViewController {
    
    var isDarkMode: Bool = false
    
    @IBOutlet weak var noEntriesLabel: UILabel!
    
    let entryController = EntryController()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 50;
        
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if entryController.entries.count >= 1 {
            noEntriesLabel.isHidden = true
        } else {
            noEntriesLabel.isHidden = false
        }
        
        tableView.reloadData()
    }
    
    func setUI() {
        if isDarkMode { navigationController?.navigationBar.barTintColor = .background
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.textColor]
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.textColor]
        navigationController?.navigationBar.tintColor = .textColor
        
            noEntriesLabel.backgroundColor = .background
            noEntriesLabel.textColor = .textColor
            
            view.backgroundColor = .background
        } else {
            navigationController?.navigationBar.barTintColor = .white
            navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
            navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
            navigationController?.navigationBar.tintColor = UIColor(red:0.07, green:0.42, blue:1.00, alpha:1.00)
            
            noEntriesLabel.backgroundColor = .white
            noEntriesLabel.textColor = .black
            
            view.backgroundColor = .white
        }
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return entryController.entries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "JournalCell", for: indexPath) as? EntryTableViewCell else { return UITableViewCell() }
        
        cell.isDarkMode = isDarkMode
        cell.entry = entryController.entries[indexPath.row]

        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            entryController.deleteEntry(entry: entryController.entries[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    @IBAction func toggleDarkMode(_ sender: Any) {
        isDarkMode = !isDarkMode
        setUI()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowJournalDetailSegue" {
            guard let detailVC = segue.destination as? EntryDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow else { return }
            detailVC.isDarkMode = isDarkMode
            detailVC.entryController = entryController
            detailVC.entry = entryController.entries[indexPath.row]
        } else if segue.identifier == "ShowAddJournalSegue" {
            guard let detailVC = segue.destination as? EntryDetailViewController else { return }
            detailVC.entryController = entryController
            detailVC.isDarkMode = isDarkMode
        }
    }
}
