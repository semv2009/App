//
//  Leadership.swift
//  TestApp
//
//  Created by developer on 04.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation
import CoreData
import BNRCoreDataStack

class Leadership: Person {
    @NSManaged var beginBusinessHours: NSDate?
    @NSManaged var endBusinessHours: NSDate?
    
    // MARK: - CoreDataModelable
    override class var entityName: String {
        return "Leadership"
    }
}
