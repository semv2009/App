//
//  PersonTableViewController.swift
//  App
//
//  Created by developer on 05.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit
import BNRCoreDataStack
import CoreData

class PersonTableViewController: UITableViewController {
    
    var stack: CoreDataStack!
    
    private lazy var fetchedResultsController: FetchedResultsController<Person> = {
        let fetchRequest = NSFetchRequest(entityName: Person.entityName)
        
        let nameSortDescriptor = NSSortDescriptor(key: "fullName", ascending:  true)
        let sectionSortDescriptor = NSSortDescriptor(key: "entity.name", ascending:  true)
        
        fetchRequest.sortDescriptors = [sectionSortDescriptor, nameSortDescriptor]
        
        let frc = FetchedResultsController<Person>(fetchRequest: fetchRequest, managedObjectContext: self.stack.mainQueueContext, sectionNameKeyPath: "entity.name")
        
        frc.setDelegate(self.frcDelegate)
        return frc
    }()
    
    private lazy var frcDelegate: PersonsFetchedResultsControllerDelegate = {
        return PersonsFetchedResultsControllerDelegate(tableView: self.tableView)
    }()

    
    init(coreDataStack stack: CoreDataStack) {
        self.stack = stack
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "List"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: nil)
        tableView.registerNib(UINib(nibName: "PersonTableViewCell", bundle: nil), forCellReuseIdentifier: "PersonCell")
        navigationItem.leftBarButtonItem = editButtonItem()
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Failed to fetch objects: \(error)")
        }
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return fetchedResultsController.sections?[section].name
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].objects.count ?? 0
    }
    
//    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        
//        var myCustomView: UIImageView
//        var myImage: UIImage = UIImage(imageLiteral: "trumpet")
//        myCustomView = UIImageView(image: myImage)
//        let myLabel = UILabel()
//        myLabel.text =  "Good"
//         let header = UIView()
//             print("good")
//            header.addSubview(myCustomView)
//            header.addSubview(<#T##view: UIView##UIView#>)
//            return header
//    }
    

    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        guard let cell =  cell as? PersonTableViewCell else { fatalError("Cell is not registered") }
        if let person = fetchedResultsController.getObject(indexPath) as? Person {
            cell.updateUI(person)
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = (tableView.dequeueReusableCellWithIdentifier("PersonCell", forIndexPath: indexPath)) as? PersonTableViewCell else { fatalError("Cell is not registered") }
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            guard let person = fetchedResultsController.getObject(indexPath) as? Person else { fatalError("Don't get task from fetchedResultsController") }
            self.stack.mainQueueContext.deleteObject(person)
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
//        var itemToMove = tableData[fromIndexPath.row]
//        tableData.removeAtIndex(fromIndexPath.row)
//        tableData.insert(itemToMove, atIndex: toIndexPath.row)
    }
    
}

extension FetchedResultsController {
    func getObject(indexPath: NSIndexPath) -> NSManagedObject {
        guard let sections = self.sections else { fatalError("Don't get sessions from fetchedResultsController") }
        return sections[indexPath.section].objects[indexPath.row]
    }
}

class PersonsFetchedResultsControllerDelegate: FetchedResultsControllerDelegate {
    
    private weak var tableView: UITableView?
    
    // MARK: - Lifecycle FetchedResultsController
    
    init(tableView: UITableView) {
        self.tableView = tableView
    }
    
    func fetchedResultsControllerDidPerformFetch(controller: FetchedResultsController<Person>) {
        tableView?.reloadData()
    }
    
    func fetchedResultsControllerWillChangeContent(controller: FetchedResultsController<Person>) {
        tableView?.beginUpdates()
    }
    
    func fetchedResultsControllerDidChangeContent(controller: FetchedResultsController<Person>) {
        tableView?.endUpdates()
    }
    
    func fetchedResultsController(controller: FetchedResultsController<Person>,
                                  didChangeObject change: FetchedResultsObjectChange<Person>) {
        switch change {
        case let .Insert(_, indexPath):
            tableView?.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            
        case let .Delete(_, indexPath):
            tableView?.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            
        case let .Move(_, fromIndexPath, toIndexPath):
            tableView?.moveRowAtIndexPath(fromIndexPath, toIndexPath: toIndexPath)
            
        case let .Update(_, indexPath):
            tableView?.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    func fetchedResultsController(controller: FetchedResultsController<Person>,
                                  didChangeSection change: FetchedResultsSectionChange<Person>) {
        switch change {
        case let .Insert(_, index):
            tableView?.insertSections(NSIndexSet(index: index), withRowAnimation: .Automatic)
            
        case let .Delete(_, index):
            tableView?.deleteSections(NSIndexSet(index: index), withRowAnimation: .Automatic)
        }
    }
}
