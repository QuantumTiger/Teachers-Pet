//
//  Universal.swift
//  Teachers_Pet
//
//  Created by WGonzalez on 4/7/17.
//  Copyright © 2017 nmalin-jones. All rights reserved.
//

import UIKit
import Foundation
import Firebase

var ref: FIRDatabaseReference
{
    return FIRDatabase.database().reference()
}

var randomCode: String
{
    return randomCode(withPattern: [4,4])
}

func randomCode(withPattern pattern: [Int]) -> String
{
    var code = ""
    let chars = [Character]("ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890".characters)
    for i in 0..<pattern.count
    {
        for _ in 0..<pattern[i]
        {
            code += "\(chars[Int(arc4random_uniform(UInt32(chars.count)))])"
        }
        if i + 1 < pattern.count
        {
            code += "-"
        }
    }
    return code
}

func set(_ val: Any, forKey key: String)
{
    ref.updateChildValues([key:val])
}


var userID: String?
{
    set (value)
    {
        UserDefaults.standard.set(value, forKey: "id")
    }
    get
    {
        return UserDefaults.standard.string(forKey: "id")
    }
}

var cancelAction: UIAlertAction
{
    return UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
}

var dismissAction: UIAlertAction
{
    return UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
}



