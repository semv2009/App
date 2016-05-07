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
        
        window?.makeKeyAndVisible()
        return true
    }
    
    func createDB() {
        let moc = coreDataStack!.newBackgroundWorkerMOC()
        do {
            try moc.performAndWaitOrThrow {
//                let person =  Accountant(managedObjectContext: moc)
//                person.fullName = "testB"
//                let person1 =  Leadership(managedObjectContext: moc)
//                person1.fullName = "testB"
//                let person2 =  FellowWorker(managedObjectContext: moc)
//                person2.fullName = "testB"
                try moc.saveContextAndWait()
            }
        } catch {
            print("Error creating inital data: \(error)")
        }
        
    }
    
    
}
