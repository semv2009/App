//
//  Person.swift
//  App
//
//  Created by developer on 08.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation
import CoreData
import BNRCoreDataStack

class Person: NSManagedObject, CoreDataModelable {
    @NSManaged var fullName: String?
    @NSManaged var salary: NSNumber?
    
    // MARK: - CoreDataModelable
    class var entityName: String {
        return "Person"
    }
}
