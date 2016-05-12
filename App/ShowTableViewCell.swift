//
//  TableViewCell.swift
//  ToDoList
//
//  Created by developer on 06.04.16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit
import BNRCoreDataStack

class ShowTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
  
    
    
    var attribute: AttributeInfo!
    
    func updateUI(attribute: AttributeInfo, person: NSManagedObject) {
        self.attribute = attribute
        
        nameLabel.text = attribute.description + ": "

        switch attribute.type {
        case .Date:
            if let value = person.valueForKey(attribute.name) as? NSDate {
                nameLabel.text =  nameLabel.text! + value.getTimeFormat()
            }
        case .Number:
            if let value = person.valueForKey(attribute.name) as? Int {
                nameLabel.text = nameLabel.text! + "\(value)"
            }
        case .String:
            if let value = person.valueForKey(attribute.name) as? String {
                nameLabel.text = nameLabel.text! + value
            }
        }
    }

}
