
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
        //Basic data pull
        super.viewDidLoad()
        let uid = FIRAuth.auth()?.currentUser?.uid
        uidTemp = uid!
        print(uidTemp)
        grabData()
    }
    
    //Pulls data from firebase to look at who needs help
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
    //Tableview setup
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return studentName.count
    }
    
    //Gets date from array and is used in the tableview
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = helpShowTableView.dequeueReusableCell(withIdentifier: "HelpShowCell", for: indexPath)
        
        let students = (studentName[indexPath.row])
        
        cell.textLabel?.text = students
        
        return cell
    }
    //Enables the teacher to remove a student after they have been helped
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
    
    //Refresshes the tableview
    @IBAction func refreshTapped(_ sender: Any)
    {
        helpShowTableView.reloadData()
    }
}
