//
//  Employee.swift
//  TestApp
//
//  Created by developer on 04.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation
import CoreData
import BNRCoreDataStack

class Employee: Person {
    @NSManaged var beginLunchTime: NSDate?
    @NSManaged var endLunchTime: NSDate?
    @NSManaged var workplace: NSNumber?
    
    override class var entityName: String {
        return "Employee"
    }
}
