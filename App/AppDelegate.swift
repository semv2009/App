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
                dispatch_async(dispatch_get_main_queue()){
                    let mainViewController = MainViewController(coreDataStack: stack)
                    self.window?.rootViewController = UINavigationController(rootViewController: mainViewController)
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
                let person = Leadership(managedObjectContext: moc)
                person.fullName = "Sam"
                person.salary = 35000
                person.beginBusinessHours = NSDate()
                person.endBusinessHours = NSDate()
                try moc.saveContextAndWait()
            }
        } catch {
            print("Error creating inital data: \(error)")
        }
        
    }
    
    
}

