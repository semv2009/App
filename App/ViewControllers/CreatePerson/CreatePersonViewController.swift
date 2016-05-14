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
    var stack: CoreDataStack
    
    var attributes = [AttributeInfo]()
    
    var delegate: ShowPersonDelegate?
    
    override func viewDidLoad() {
       super.viewDidLoad()
        configureSegmentedControl(person)
        configureView()
        createBarButtons()
        
        // Do any additional setup after loading the view.
    }

    init(coreDataStack stack: CoreDataStack) {
        self.stack = stack
        super.init(nibName: nil, bundle: nil)
    }
    
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
            if let newPerson = newPerson {
                attributes = newPerson.getAttributes()
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
        if checkAllTextField() {
            if let newPerson = newPerson {
                for cell in tableView.visibleCells {
                    if let personCell = cell as? DataTableViewCell {
                        newPerson.setValue(personCell.value, forKey: personCell.attribute.name)
                        delegate?.person = newPerson
                    }
                }
                if let person = person {
                    self.stack.mainQueueContext.deleteObject(person)
                }
                
            } else {
                if let person = person {
                    for cell in tableView.visibleCells {
                        if let personCell = cell as? DataTableViewCell {
                            person.setValue(personCell.value, forKey: personCell.attribute.name)
                            delegate?.person = person
                        }
                    }
                }
            }
            dismissViewControllerAnimated(true, completion: nil)
        }
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
            switch nameEntity {
            case Accountant.entityName:
                newPerson = Accountant(managedObjectContext: self.stack.mainQueueContext)
                newPerson?.copyData(lastPerson)
                self.attributes = newPerson!.getAttributes()
            case Leadership.entityName:
                newPerson = Leadership(managedObjectContext: self.stack.mainQueueContext)
                newPerson?.copyData(lastPerson)
                self.attributes = newPerson!.getAttributes()
            case FellowWorker.entityName:
                newPerson = FellowWorker(managedObjectContext: self.stack.mainQueueContext)
                newPerson?.copyData(lastPerson)
                self.attributes = newPerson!.getAttributes()
            default:
                break
            }
            if lastPerson != self.person {
                self.stack.mainQueueContext.deleteObject(lastPerson)
            }
            tableView.reloadData()
        }
    }
    
    func checkAllTextField() -> Bool {
        var count = 0
        for cell in tableView.visibleCells {
            if let personCell = cell as? DataTableViewCell {
                count = count + personCell.checkEmptyValue()
            }
        }
        if count > 0 {
            let alert = UIAlertController(title: "Warning", message: "There are empty fields.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Okey", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    // MARK: - Table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return  1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  attributes.count ?? 0
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
    var optional: Int
}

enum TypeAttribute: Int {
    case String = 700
    case Date = 900
    case Number = 300
}
