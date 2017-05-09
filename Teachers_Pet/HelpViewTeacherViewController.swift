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
        grabData()
//        print("This is the class Number \(classNumber)")
    }
    
    func grabData()
    {
        ref.child("Users/\(uidTemp)/Teacher/Help Section").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject]
            {
                let studentsCount = dictionary.count
                
                ref.child("Users/\(self.uidTemp)/Teacher/Help Section").observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    if let dictionary = snapshot.value as? [String: AnyObject]
                    {
                        let studentsShow = dictionary["StudentName\(studentsCount)"] as? String
                        self.studentName.append(studentsShow!)
                        self.helpShowTableView.reloadData()
                    }
                    
                }, withCancel: nil)
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
        
        let students = ("\(studentName.count). " + studentName[indexPath.row])
        
        cell.textLabel?.text = students
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            print("Deleted")
            
            //loopAndUpdate(index: indexPath)
            
            studentName.remove(at: indexPath.row)
            print([indexPath.row])
            helpShowTableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    
    func loopAndUpdate(index : IndexPath)
    {
//        for number in 1...1
//        {
            ref.child("Users/\(self.uidTemp)/Teacher/Help Section").observeSingleEvent(of: .value, with: { (snapshot) in

                let updateWithValues = ["StudentName1" : self.studentName[index.row]]
//                self.studentName[index.row]
                print(updateWithValues)
                
                
            }, withCancel: nil)
//        }
    }
    
}
