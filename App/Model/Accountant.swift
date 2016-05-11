//
//  Accountant.swift
//  App
//
//  Created by developer on 08.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation
import CoreData
import BNRCoreDataStack

class Accountant: Employee {
    @NSManaged var type: String?
    
    // MARK: - CoreDataModelable
    override class var entityName: String {
        return "Accountant"
    }
    
    func getKeyForData() -> [String] {
        var array = [String]()
        array.append("type")
        return super.getKeyForData(array)
    }
}
