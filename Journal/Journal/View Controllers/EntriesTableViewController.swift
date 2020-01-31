//
//  EntriesTableViewController.swift
//  Journal
//
//  Created by Kat Milton on 7/22/19.
//  Copyright © 2019 Kat Milton. All rights reserved.
//

import UIKit
import CoreData

class EntriesTableViewController: UITableViewController, UICollectionViewDelegate, UICollectionViewDataSource, NSFetchedResultsControllerDelegate {
    
    
    
    // MARK: - IBOutlets and Variables
    @IBOutlet var yearsCollectionContainerView: UIView!
    @IBOutlet var yearsCollectionView: UICollectionView!

    var entryController = EntryController()
    
    var years: Int? = 0
    var selectedYear: String? = nil
    var numberOfSections: Int? = 0
    var months: [String] = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    var sectionsToDisplay: [String] = []
    var currentYear: String? = nil
    
    var dateFormatter = DateFormatter()
    
    
    // MARK: - NSFetchedResultsController
    
    lazy var fetchedResultsController: NSFetchedResultsController<Entry> = {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        
//        let moodDescripter = NSSortDescriptor(key: "mood", ascending: true)
        let yearDescriptor = NSSortDescriptor(key: "year", ascending: true)
        let monthDescriptor = NSSortDescriptor(key: "month", ascending: false)
        
        fetchRequest.sortDescriptors = [yearDescriptor]
        let moc = CoreDataStack.shared.mainContext
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: "year", cacheName: nil)
        
        frc.delegate = self
        
        do {
            try frc.performFetch()
        } catch {
            fatalError("Error performing fetch: \(error)")
        }
        return frc
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
           try fetchedResultsController.performFetch()
       } catch {
           print("An error occurred")
       }
        self.navigationController?.navigationBar.prefersLargeTitles = true
        yearsCollectionView.dataSource = self
        yearsCollectionView.delegate = self
        
        currentYear = determineCurrentYear()
        selectedYear = currentYear
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        selectedYear = currentYear
//        tableView.reloadData()
        
        
//        entryController.fetchEntriesFromServer()
    }
    
    // MARK: - Year Collection View data source
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        
        if let datesToSort = fetchedResultsController.fetchedObjects {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        formatter.dateFormat = "yyyy"



            for y in datesToSort {
                print(y)
            }
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
//        var yearsInCollectionView = years
        
        
        return UICollectionViewCell()
        
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        <#code#>
//    }
    
    
    // MARK: - CRUD methods
    
    func determineCurrentYear() -> String {
        
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .short
        dateFormatter.dateFormat = "yyyy"
        
        let date = Date()
        
        let currentYear = dateFormatter.string(from: date)

        return currentYear
    }
    
    func selectYear(date: Date) -> String {
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .short
        dateFormatter.dateFormat = "yyyy"
        
        let currentYear = dateFormatter.string(from: date)

        return currentYear
        
    }
    
    func getMonth(date: Date) -> String {
        
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .short
        dateFormatter.dateFormat = "MMMM"
        
        let dateString = dateFormatter.string(from: date)
        
        return dateString
    }
    
    func fetchEntries() -> [Entry]? {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("error fetching entries")
        }
        
        guard var entries = fetchedResultsController.fetchedObjects else { return nil }
        
        return entries
        
    }
    
    



    // MARK: - Table view data source
    
    // core data error in one of the sections methods
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        // 1. Divide sections by year and month
        // 2. Return the number of sections that apply.
        
//        guard let sectionInfo = fetchedResultsController.sections?.description else { return 0 }
//              let formatter = DateFormatter()
//              formatter.timeStyle = .short
//              formatter.dateStyle = .short
//              formatter.dateFormat = "MMMM yyyy"
//              let formattedDate = formatter.date(from: sectionInfo) ?? Date()
//              let dateString = formatter.string(from: formattedDate)
//              var sectionsToReturn: Int? = 0
//              
//              if dateString.contains("January") {
//                  sectionsToReturn
//              }
        
        guard var entries = fetchEntries()?.filter({ $0.year == selectedYear }) else { return 0 }
        
        var monthsToDisplay: [String] = []
        var monthCount: Int = 0
        
        for x in entries {
            
            if let month = x.month {
            
                if !monthsToDisplay.contains(month) {
                    monthsToDisplay.append(month)
                    monthCount += 1
                }
            }
            
        }
        
//        if let currentSection = entries[section].month {
//            for x in entries {
//                if currentSection == x.month {
//                    rowsForSection += 1
//                }
//            }
//        }
        
        let sectionsToReturn = monthsToDisplay.count
        
         return monthCount
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Not counting entries in month properly
        
        guard var entries = fetchEntries()?.filter({ $0.year == selectedYear }) else { return 0 }
        
        print(entries.count)
        
        var rowsForSection: Int = 0
        
        
        
        if let currentSection = entries[section].month {
            for x in entries {
                if currentSection == x.month {
                    rowsForSection += 1
                }
            }
        }
        
        
        
        return rowsForSection
        
//        return currentSection?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var sectionHeaders: [String] = []
        
        guard var entries = fetchEntries() else { return nil }
        
        
        
        for x in entries {
            
            if let month = x.month {
            
                if !sectionHeaders.contains(month) {
                    sectionHeaders.append(month)
                }
            }
            
        }
        var nameOfSection: String = ""
        
        for e in sectionHeaders {
            nameOfSection = e
        }
        
        sectionHeaders = sectionsToDisplay

        return nameOfSection
        
//        var sectionHeaders: [String] = []
//
//        guard var entries = fetchEntries() else { return nil }
//
//
//        for x in entries {
//
//            guard let dateToFormat = x.timeStamp else { return nil }
//
//            let dateString = getMonth(date: dateToFormat)
//
//            if !months.contains(dateString) {
//
//            } else if months.contains(dateString) {
//                if !sectionHeaders.contains(dateString) {
//                 sectionHeaders.append(dateString)
//                }
//
//            }
//
//            numberOfSections = sectionHeaders.count
//
//        }
//
//        var nameOfSection: String = ""
//
//        for e in sectionHeaders {
//            nameOfSection = e
//        }
//
//
//        return nameOfSection
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = AppearanceHelper.highlightColor.withAlphaComponent(0.4)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as! EntryTableViewCell
        
        guard var entries = fetchEntries()?.filter({ $0.year == selectedYear }) else { return UITableViewCell() }
        
        
        
        let entry = entries[indexPath.row]
        
        
        cell.entry = entry

        return cell
    }
    

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let entry = fetchedResultsController.object(at: indexPath)
            entryController.deleteEntry(entry: entry)

        }
    }


    
    // MARK: - Navigation

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddJournalEntry" {
            guard let detailVC = segue.destination as? EntryDetailViewController else { return }
            
            detailVC.entryController = entryController
            
        } else if segue.identifier == "ShowJournalEntry" {
            guard let detailVC = segue.destination as? EntryDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow else { return }
            
            detailVC.entryController = entryController
            detailVC.entry = fetchedResultsController.object(at: indexPath)
        }
    }
}

extension EntriesTableViewController {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()


    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()


    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

        switch type {

        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.reloadData()
        case .move:
            guard let indexPath = indexPath,
                let newIndexPath = newIndexPath else { return }
           
            tableView.moveRow(at: indexPath, to: newIndexPath)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)

        @unknown default:
            break
        }

    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {

        let sections = IndexSet(integer: sectionIndex)
        switch type {
        case .insert:
            tableView.insertSections(sections, with: .automatic)
        case .delete:
            tableView.deleteSections(sections, with: .automatic)
        default:
            break
        }

    }
    
}


