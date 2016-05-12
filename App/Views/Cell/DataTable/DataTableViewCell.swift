//
//  TableViewCell.swift
//  ToDoList
//
//  Created by developer on 06.04.16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit
import CoreData

class DataTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dataTextField: UITextField!
    
    var attribute: AttributeInfo!
    
    var datePiсker = UIDatePicker()
    
    func updateUI(attribute: AttributeInfo, person: NSManagedObject) {
        self.attribute = attribute
        
        nameLabel.text = attribute.description
        dataTextField.addTarget(self, action: #selector(DataTableViewCell.dataEditTextChanged(_:)), forControlEvents: .EditingChanged)
        
        switch attribute.type {
        case .Date:
            datePiсker.datePickerMode = .Time
            dataTextField.inputView = datePiсker
            datePiсker.addTarget(self, action: #selector(DataTableViewCell.datePickerChanged(_:)), forControlEvents: .ValueChanged)
            if let value = person.valueForKey(attribute.name) as? NSDate {
                dataTextField.text = value.getTimeFormat()
            } else {
                dataTextField.text = ""
            }
        case .Number:
            if let value = person.valueForKey(attribute.name) as? Int {
                dataTextField.text = "\(value)"
            } else {
                dataTextField.text = ""
            }
            dataTextField.keyboardType = .NumbersAndPunctuation
        case .String:
            if let value = person.valueForKey(attribute.name) as? String {
                dataTextField.text = value
            } else {
                dataTextField.text = ""
            }
        }
    }
    
    func checkEmptyValue() -> Int {
        if attribute.optional == 0 {
            if dataTextField.text?.characters.count == 0 {
                dataTextField.backgroundColor = UIColor.redColor()
                return 1
            }
        }
        return 0
    }
    
    func dataEditTextChanged(sender: UITextField) {
        sender.backgroundColor = UIColor.whiteColor()
    }
    
    func datePickerChanged(sender: UIDatePicker) {
        dataTextField.text = datePiсker.date.getTimeFormat()
    }
    
    var value: AnyObject? {
        switch attribute.type {
        case .Date:
            if let text = dataTextField.text {
                if text.characters.count > 0 {
                    return datePiсker.date
                }
            }
            return nil
        case .Number:
            if let text = dataTextField.text {
                return Int(text)
            } else {
                return nil
            }
        case .String:
            return dataTextField.text
        }
    }

}
