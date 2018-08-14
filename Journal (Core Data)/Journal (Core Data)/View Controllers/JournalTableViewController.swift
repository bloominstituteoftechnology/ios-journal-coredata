//
//  ViewController.swift
//  Journal (Core Data)
//
//  Created by Simon Elhoej Steinmejer on 13/08/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import UIKit

class JournalTableViewController: UITableViewController
{
    let entryController = EntryController()
    let cellId = "entryCell"

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.register(EntryCell.self, forCellReuseIdentifier: cellId)
        
        setupNavBar()
    }

    private func setupNavBar()
    {
        title = "Journal"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleNewEntry))
    }
    
    @objc private func handleNewEntry()
    {
        let entryDetailViewController = EntryDetailViewController()
        entryDetailViewController.entryController = self.entryController
        navigationController?.pushViewController(entryDetailViewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return entryController.entries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EntryCell
        
        let entry = entryController.entries[indexPath.row]
        
        cell.textLabel?.text = entry.title
        cell.detailTextLabel?.text = entry.note
        
        if let timestamp = entry.timestamp
        {
            cell.timestampLabel.text = timestamp.toString(dateFormat: "EEE hh:mm a")
        }
 
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let entryDetailViewController = EntryDetailViewController()
        entryDetailViewController.entry = entryController.entries[indexPath.row]
        entryDetailViewController.entryController = self.entryController
        navigationController?.pushViewController(entryDetailViewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 60
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            let entry = entryController.entries[indexPath.row]
            entryController.deleteEntry(on: entry)
            tableView.reloadData()
        }
    }

}







