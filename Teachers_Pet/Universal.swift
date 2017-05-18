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

func updateFire(fireBasePull: String, array : Array<Any>,fireBasePush: String)
{
    ref.child(fireBasePull).observeSingleEvent(of: .value, with: { (snapshot) in
        
        if let dictionary = snapshot.value as? [String: AnyObject]
        {
            let studentsCount = (dictionary.count - 1)
            let refPush = ref.child(fireBasePush)
            
            if studentsCount > 0
            {
                refPush.removeValue()
                
                for number in 1...studentsCount
                {
                    let updateWithValues = ["StudentName\(number)" : array[number - 1]]
                    print(updateWithValues)
                    refPush.updateChildValues(updateWithValues)
                }
            }
                
            else if studentsCount == 0
            {
                print("No one needs helps")
                refPush.removeValue()
            }
        }
        
    }, withCancel: nil)
}


var dismissAction: UIAlertAction
{
    return UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
}



