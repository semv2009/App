//
//  MainViewController.swift
//  TestApp
//
//  Created by developer on 04.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit
import CoreData
import BNRCoreDataStack

class MainViewController: UIViewController {
    var stack: CoreDataStack!
    
    init(coreDataStack stack: CoreDataStack) {
        super.init(nibName: nil, bundle: nil)
        self.stack = stack

    }
    
    required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("ds")
        
        
        let moc = stack!.newBackgroundWorkerMOC()
        do {
            let person = try  Accountant.allInContext(moc)
            print(person.first)
        // print(person)
        print("Accountant = \(person.count)")
        let personw = try  FellowWorker.allInContext(moc)
        
        print("FellowWorker = \(personw.count)")
        var voitures: [Leadership]? = try  Leadership.allInContext(moc)

        } catch {
            print("Error creating inital data: \(error)")
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
