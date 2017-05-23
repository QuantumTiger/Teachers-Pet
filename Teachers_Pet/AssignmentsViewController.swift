//
//  AssignmentsViewController.swift
//  Teachers_Pet
//
//  Created by WGonzalez on 5/23/17.
//  Copyright © 2017 nmalin-jones. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import ChameleonFramework
import SCLAlertView

class AssignmentsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    var uidTemp = String()
    var assignmentsShow = [String]()
    
    @IBOutlet weak var assignmentsTableView: UITableView!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let uid = FIRAuth.auth()?.currentUser?.uid
        uidTemp = uid!
        grabData()
    }
    
    func grabData()
    {
        ref.child("Users/\(uidTemp)/Teacher/Assignments").observeSingleEvent(of: .value, with: { (snapshot) in
    
            if let dictionary = snapshot.value as? [String: AnyObject]
            {
                for number in 1...dictionary.count
                {
                    print(dictionary.count)
                    let assignments = dictionary["Assignment\(number)"] as? String
                    self.assignmentsShow.append(assignments!)
                    self.assignmentsTableView.reloadData()
                }
            }
            
            }, withCancel: nil)
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return assignmentsShow.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = assignmentsTableView.dequeueReusableCell(withIdentifier: "Assignments", for: indexPath)
        
        let classes = assignmentsShow[indexPath.row]
        
        cell.textLabel?.text = classes
        
        return cell
    }
    

}
