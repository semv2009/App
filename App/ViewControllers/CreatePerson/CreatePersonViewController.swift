//
//  CreatePersonViewController.swift
//  App
//
//  Created by developer on 09.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit
import BNRCoreDataStack

class CreatePersonViewController: UIViewController, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var personSegmentedControl: UISegmentedControl!
    
    var person: NSManagedObject?
    var newPerson: NSManagedObject?
    
    var doneButton: UIBarButtonItem!
    var stack: CoreDataStack!
    
    var attributes = [AttributeInfo]()
    
    override func viewDidLoad() {
       super.viewDidLoad()
        configureView()
        configureSegmentedControl(person)
        createBarButtons()
        
        // Do any additional setup after loading the view.
    }

    init(coreDataStack stack: CoreDataStack) {
        self.stack = stack
        super.init(nibName: nil, bundle: nil)
    }
    var delegate: DeletePerson!
    
    required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    
    // MARK: Navigator
    func configureView() {
        tableView.delegate = self
        tableView.registerNib(UINib(nibName: "DataTableViewCell", bundle: nil), forCellReuseIdentifier: "DataCell")
        if let person = person {
            title = "Update profile"
            attributes = person.getAttributes()
        } else {
            title = "Create profile"
            person = FellowWorker(managedObjectContext: self.stack.mainQueueContext)
            newPerson = FellowWorker(managedObjectContext: self.stack.mainQueueContext)
            if let person = person {
                attributes = person.getAttributes()
            }
        }
    }
    
    
    func configureSegmentedControl(person: NSManagedObject?) {
        if let person = person, entity = person.entity.name {
            switch entity {
            case Accountant.entityName:
                personSegmentedControl.selectedSegmentIndex = 2
            case Leadership.entityName:
                personSegmentedControl.selectedSegmentIndex = 1
            case FellowWorker.entityName:
                personSegmentedControl.selectedSegmentIndex = 0
            default:
               break
            }
        }
    
    }
    
    func createBarButtons() {
        self.navigationController?.navigationBar.translucent = false
        self.edgesForExtendedLayout = UIRectEdge.None
        doneButton =  UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: #selector(CreatePersonViewController.done))
        navigationItem.rightBarButtonItem = doneButton
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(CreatePersonViewController.dismiss))
    }
    
    @objc private func dismiss() {
        if let newPerson = newPerson {
            self.stack.mainQueueContext.deleteObject(newPerson)
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @objc private func done() {
        if let newPerson = newPerson {
            if let person = person {
                //self.stack.mainQueueContext.deleteObject(person)
                if let delegate = delegate {
                    print("Set delegate")
                    delegate.deletePerson(person)
                }
                
                
            }
            for cell in tableView.visibleCells {
                if let personCell = cell as? DataTableViewCell {
                     newPerson.setValue(personCell.value, forKey: personCell.attribute.name)
                }
            }
            self.stack.mainQueueContext.insertObject(newPerson)
            
            
        } else {
            if let person = person {
                for cell in tableView.visibleCells {
                    if let personCell = cell as? DataTableViewCell {
                        person.setValue(personCell.value, forKey: personCell.attribute.name)
                    }
                }
                self.stack.mainQueueContext.insertObject(person)
            }
        }
        dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: -Segment controller action
    
    @IBAction func changeValueSegmentController(sender: UISegmentedControl) {
        let select = sender.selectedSegmentIndex
        if let nameSegment = personSegmentedControl.titleForSegmentAtIndex(select) {
            updateTableView(nameSegment)
        }
    }
    
    func updateTableView(nameEntity: String) {
        var lastPerson: NSManagedObject?
        
        if let newPerson = newPerson {
            lastPerson = newPerson
        } else {
            lastPerson = person
        }
        
        if let lastPerson = lastPerson {
            var nperson: NSManagedObject?
            
            switch nameEntity {
            case Accountant.entityName:
                nperson = Accountant(managedObjectContext: self.stack.mainQueueContext)
                //nperson!.copyData(lastPerson)
                self.attributes = nperson!.getAttributes()
            case Leadership.entityName:
                nperson = Leadership(managedObjectContext: self.stack.mainQueueContext)
                //nperson!.copyData(lastPerson)
                self.attributes = nperson!.getAttributes()
            case FellowWorker.entityName:
                nperson = FellowWorker(managedObjectContext: self.stack.mainQueueContext)
                //nperson!.copyData(lastPerson)
                self.attributes = nperson!.getAttributes()
            default:
                break
            }
            if lastPerson != self.person {
                self.stack.mainQueueContext.deleteObject(lastPerson)
            }
            
            self.newPerson = nperson
            tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return  1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  attributes.count
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        guard let cell =  cell as? DataTableViewCell else { fatalError("Cell is not registered") }
        if let newPerson = newPerson {
            cell.updateUI(attributes[indexPath.row], person: newPerson)

        } else {
            if let person = person {
                cell.updateUI(attributes[indexPath.row], person: person)
            }
        }
        
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = (tableView.dequeueReusableCellWithIdentifier("DataCell", forIndexPath: indexPath)) as? DataTableViewCell else { fatalError("Cell is not registered") }
        return cell
    }
}

struct  AttributeInfo {
    var name: String
    var order: Int
    var description: String
    var type: TypeAttribute
}

enum TypeAttribute: Int {
    case String = 700
    case Date = 900
    case Number = 300
}
