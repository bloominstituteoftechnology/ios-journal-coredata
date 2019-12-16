//
//  EntriesTableViewController.swift
//  Journal
//
//  Created by Chad Rutherford on 12/16/19.
//  Copyright © 2019 Chad Rutherford. All rights reserved.
//

import SwiftUI
import UIKit

class EntriesTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Journal"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAddTapped))
    }
    
    @objc private func handleAddTapped() {
        let entryDetailVC = EntryDetailViewController()
        navigationController?.pushViewController(entryDetailVC, animated: true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.journalCell, for: indexPath)
        return cell
    }
}

struct JournalPreview: PreviewProvider {
    static var previews: some View {
        ContainerView()
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        func updateUIViewController(_ uiViewController: JournalPreview.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<JournalPreview.ContainerView>) {
            
        }
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<JournalPreview.ContainerView>) -> UIViewController {
            return UINavigationController(rootViewController: EntriesTableViewController())
        }
    }
}
