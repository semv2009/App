//
//  AppDelegate.swift
//  App
//
//  Created by developer on 05.05.16.
//  Copyright © 2016 developer. All rights reserved.
//
import UIKit
import BNRCoreDataStack


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var coreDataStack: CoreDataStack?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = LoadingViewController()
        
        CoreDataStack.constructSQLiteStack(withModelName: "Model") {[unowned self]result in
            switch result {
            case .Success(let stack):
                self.coreDataStack = stack
                self.createDB()
                dispatch_async(dispatch_get_main_queue()) {
                    let mainViewController = MainTabViewController(coreDataStack: self.coreDataStack!)
                    self.window?.rootViewController = mainViewController
                }
                
            case .Failure(let error):
                assertionFailure("\(error)")
            }
        }
        print()
        window?.makeKeyAndVisible()
        return true
    }
    
    func createDB() {
        let moc = coreDataStack!.newBackgroundWorkerMOC()
        do {
            try moc.performAndWaitOrThrow {
//                let person =  Accountant(managedObjectContext: moc)
//                person.fullName = "Accountant"
//                person.salary = 99
//                person.type = "Buy"
//                person.beginLunchTime = NSDate()
//                person.endLunchTime = NSDate()
//                person.workplace = 46
//                
//                let person1 =  Leadership(managedObjectContext: moc)
//                person1.fullName = "Leadership"
//                person1.salary = 3434
//                person1.beginBusinessHours = NSDate()
//                person1.endBusinessHours = NSDate()
//                
//                let person2 =  FellowWorker(managedObjectContext: moc)
//                person2.fullName = "FellowWorker"
//                person2.salary = 43
//                person2.beginLunchTime = NSDate()
//                person2.endLunchTime = NSDate()
//                person2.workplace = 46
//                try moc.saveContextAndWait()
            }
        } catch {
            print("Error creating inital data: \(error)")
        }
        
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        guard let stack = coreDataStack else {
            assertionFailure("Stack was not setup first")
            return
        }
        do {
            print("Save context")
            try stack.mainQueueContext.save()
        } catch {
            print(error)
        }
    }
    
    
}
