//
//  MasterViewController.swift
//  Lab4
//
//  Created by MO X02a on 2020-01-27.
//  Copyright © 2020 ics052. All rights reserved.
//

import UIKit
import os

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = [PhotoEntry]()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // attempt to make object be loaded from file
        let loadedObjects = loadObjects()
        if loadedObjects != nil{
            objects = loadedObjects!
        }
        
        
        navigationItem.leftBarButtonItem = editButtonItem

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
        if DetailViewController.didChange{
            saveObjects()
            tableView.reloadData()
            DetailViewController.didChange = false
        }
    }

    @objc
    func insertNewObject(_ sender: Any) {
        objects.insert(PhotoEntry(photo: UIImage(named: "defaultImage")!, notes: "My notes"), at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        saveObjects()
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.entry = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
                detailViewController = controller
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as!PhotoEntryTableViewCell
        let object = objects[indexPath.row]
        cell.photoView.image = object.photo
        cell.notesView.text = object.notes
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveObjects()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }

    // Mark: - Load/Save
    
    // 
    
    func loadObjects() -> [PhotoEntry]? { // function declaration for loading an object. returns a PhotoEntry, or nil.
        do {
            let data = try Data(contentsOf: PhotoEntry.archiveURL) // variable data is assigned whatever we find in the archiveUrl value of the PhotoEntry class.
            return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [PhotoEntry] // returns the data retrieved as a PhotoEntry
        } catch {
            os_log("Cannot load due to %@", log: OSLog.default, type: .debug, error.localizedDescription)
            return nil
        }
    }

    func saveObjects(){
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: objects, requiringSecureCoding: false) // data is assigned whatever is retrieved from objects array.
            try data.write(to: PhotoEntry.archiveURL) // writes the data to the specified url.
        } catch {
            os_log("Cannot save due to %@", log: OSLog.default, type: .debug, error.localizedDescription)
        }
    }
}

