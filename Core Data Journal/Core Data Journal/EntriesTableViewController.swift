//
//  EntriesTableViewController.swift
//  Core Data Journal
//
//  Created by Michael Redig on 5/27/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import UIKit

class EntriesTableViewController: UITableViewController {
	override func viewDidLoad() {
		super.viewDidLoad()

		tableView.register(EntryTableViewCell.self, forCellReuseIdentifier: "EntryCell")
	}
}

// MARK: - table stuff
extension EntriesTableViewController {
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 3
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath)
		guard let entryCell = cell as? EntryTableViewCell else { return cell }

		entryCell.titleLabel.text = "title!"
		return entryCell
	}
}
