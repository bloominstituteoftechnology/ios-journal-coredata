//
//  EntryTableViewCell.swift
//  MyJournal
//
//  Created by Eoin Lavery on 02/10/2019.
//  Copyright © 2019 Eoin Lavery. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    //MARK: - IBOUTLETS
    @IBOutlet weak var entryTitleLabel: UILabel!
    @IBOutlet weak var entryTimestampLabel: UILabel!
    @IBOutlet weak var entryNotesLabel: UILabel!

    //MARK: - PROPERTIES
    var entry: Entry?
    var entryController: EntriesController?
    
}
