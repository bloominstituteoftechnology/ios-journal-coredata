//
//  JournalTableViewController.swift
//  Journal
//
//  Created by Chris Gonzales on 2/24/20.
//  Copyright © 2020 Chris Gonzales. All rights reserved.
//

import UIKit

class EntriesTableViewController: UITableViewController {
    
    // MARK: - Propeties
    
    let entries: [Entry] = []
    
    
    // MARK: - Outlets
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var timestampLabel: UILabel!
    @IBOutlet var entryTextLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Keys.entryCellName, for: indexPath) as? EntryTableViewCell else { return UITableViewCell() }
        if entries.count > 0 {
        cell.entryTitleLabel.text = entries[indexPath.row].title
        cell.entryDescriptionText.text = entries[indexPath.row].bodyText
        cell.timeStamp.text = CustomDateFormatter.dateFormat(date: entries[indexPath.row].timestamp!,
                                                             format: "DD MMM YY")
        return cell
        } else { return UITableViewCell()}
        
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}
