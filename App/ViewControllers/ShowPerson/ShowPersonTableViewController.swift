//
//  ShowPersonTableViewController.swift
//  App
//
//  Created by developer on 12.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit
import BNRCoreDataStack

class ShowPersonTableViewController: UITableViewController, ShowPersonDelegate {
    
    var person: NSManagedObject? {
        didSet {
            if let person = person, entity = person.entity.name {
                title = entity
                attributes = person.getAttributes()
                tableView.reloadData()
            }
        }
    }
    
    var stack: CoreDataStack!
    
    var editButton: UIBarButtonItem!
    
    var attributes = [AttributeInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        createBarButtons()
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
        tableView.registerNib(UINib(nibName: "ShowTableViewCell", bundle: nil), forCellReuseIdentifier: "ShowCell")
    }
    
    
    func createBarButtons() {
        self.navigationController?.navigationBar.translucent = false
        self.edgesForExtendedLayout = UIRectEdge.None
        editButton =  UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: #selector(ShowPersonTableViewController.edit))
        navigationItem.rightBarButtonItem = editButton
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(ShowPersonTableViewController.dismiss))
    }

    @objc private func dismiss() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @objc private func edit() {
        let createVC = CreatePersonViewController(coreDataStack: stack)
        createVC.person = person
        createVC.delegate = self
        showViewController(UINavigationController(rootViewController: createVC), sender: self)
    }
    

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return  1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  attributes.count ?? 0
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        guard let cell =  cell as? ShowTableViewCell else { fatalError("Cell is not registered") }
        if let person = person {
           cell.updateUI(attributes[indexPath.row], person: person)
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = (tableView.dequeueReusableCellWithIdentifier("ShowCell", forIndexPath: indexPath)) as? ShowTableViewCell else { fatalError("Cell is not registered") }
        return cell
    }

}

protocol ShowPersonDelegate {
    var person: NSManagedObject? { get set }
}
