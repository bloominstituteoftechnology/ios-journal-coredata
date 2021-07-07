//
//  EntriesTableViewController.swift
//  Core Data Journal
//
//  Created by Michael Redig on 5/27/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import UIKit

class EntriesTableViewController: UITableViewController {

	let entryController = EntryController()

	override func viewDidLoad() {
		super.viewDidLoad()

		tableView.register(EntryTableViewCell.self, forCellReuseIdentifier: "EntryCell")
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		tableView.reloadData()
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let dest = segue.destination as? EntryDetailViewController {
			dest.entryController = entryController
		}
	}
}

// MARK: - table stuff
extension EntriesTableViewController {
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return entryController.entries.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath)
		guard let entryCell = cell as? EntryTableViewCell else { return cell }

		entryCell.entry = entryController.entries[indexPath.row]
		return entryCell
	}

	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			guard let entryCell = tableView.cellForRow(at: indexPath) as? EntryTableViewCell, let entry = entryCell.entry else { return }
			entryController.delete(entry: entry)
			tableView.deleteRows(at: [indexPath], with: .automatic)
		}
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let detailVC = storyboard?.instantiateViewController(withIdentifier: "EntryDetail") as? EntryDetailViewController else { return }
		guard let entry = (tableView.cellForRow(at: indexPath) as? EntryTableViewCell)?.entry else { return }
		detailVC.entryController = entryController
		detailVC.entry = entry

		navigationController?.pushViewController(detailVC, animated: true)
	}
}
