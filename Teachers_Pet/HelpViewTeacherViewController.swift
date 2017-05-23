
//
//  HelpViewTeacherViewController.swift
//  Teachers_Pet
//
//  Created by WGonzalez on 5/8/17.
//  Copyright © 2017 nmalin-jones. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class HelpViewTeacherViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var helpShowTableView: UITableView!
    
    var uidTemp = String()
    var studentName = [String]()
    var teacherID = String()
    var classNumber = String()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let uid = FIRAuth.auth()?.currentUser?.uid
        uidTemp = uid!
        print(uidTemp)
        grabData()
    }
    
    func grabData()
    {
        ref.child("Users/\(uidTemp)/Teacher/Help Section").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject]
            {
                let studentsCount = dictionary.count
                
                for number in 1...studentsCount
                {
                    let studentsShow = dictionary["StudentName\(number)"] as! String
                    self.studentName.append(studentsShow)
                    self.helpShowTableView.reloadData()
                }
            }
            
        }, withCancel: nil)
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return studentName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = helpShowTableView.dequeueReusableCell(withIdentifier: "HelpShowCell", for: indexPath)
        
        let students = (studentName[indexPath.row])
        
        cell.textLabel?.text = students
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            print("Deleted")
            studentName.remove(at: indexPath.row)
            print([indexPath.row + 1])
            helpShowTableView.deleteRows(at: [indexPath], with: .automatic)
            updateFire(fireBaseString: "Users/\(uidTemp)/Teacher/Help Section", array: studentName)
            helpShowTableView.reloadData()
        }
    }
    
    @IBAction func refreshTapped(_ sender: Any) {
        helpShowTableView.reloadData()
    }
}
