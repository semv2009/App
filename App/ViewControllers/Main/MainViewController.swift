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
        let moc = stack!.newBackgroundWorkerMOC()
        do{
        let person = try  Accountant.allInContext(moc)
        print("Accountant = \(person.count)")
        let personw = try  FellowWorker.allInContext(moc)
        print("FellowWorker = \(personw.count)")
        let personq = try  Leadership.allInContext(moc)
        print("Leadership = \(personq.count)")
    
            
        } catch {
            print("Error creating inital data: \(error)")
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
