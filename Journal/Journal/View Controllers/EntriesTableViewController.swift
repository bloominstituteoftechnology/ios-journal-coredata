//
//  EntriesTableViewController.swift
//  Journal
//
//  Created by Jake Connerly on 8/19/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import UIKit

class EntriesTableViewController: UIViewController {
    
    // MARK: - IBOutlets & Properties

    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }
    

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}

// MARK: - Extensions

extension EntriesTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
}
