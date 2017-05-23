//
//  HelpViewTeacherViewController.swift
//  Teachers_Pet
//
//  Created by YOURNAME on 5/8/17.
//  Copyright © 2017 nmalin-jones. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class TeacherClassMainMenu: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    
    @IBOutlet weak var teacherDetailTableView: UITableView!
    
    var uidTemp = String()
    var classNumberFromPrevious = String()
    var studentsInClass = [String]()
    var codesFromClass = [String]()
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let uid = FIRAuth.auth()?.currentUser?.uid
        uidTemp = uid!
        grabData()
        
        navigationController?.isNavigationBarHidden = true
    }

    func grabData()
    {
        ref.child("Users/\(uidTemp)/Teacher/ClassName\(self.classNumberFromPrevious)/Students Enrolled").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject]
            {
                let studentsCount = dictionary.count
                
                print(studentsCount)
                ref.child("Users/\(self.uidTemp)/Teacher/ClassName\(self.classNumberFromPrevious)/Students Enrolled").observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    for number in 1...studentsCount
                    {
                        if let dictionary = snapshot.value as? [String: AnyObject]
                        {
                            let students = dictionary["StudentName\(number)"] as! String
                            self.studentsInClass.append(students)
                            self.teacherDetailTableView.reloadData()
                        }
                    }
                    
                }, withCancel: nil)
            }
            
        }, withCancel: nil)
    
    }
    @IBAction func addAssignment(_ sender: Any)
    {
        let actions = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actions.addAction(UIAlertAction(title: "Enter Assignment", style: .default, handler: assignmentCreation))
        actions.addAction(cancelAction)
        present(actions, animated: true, completion: nil)
    }
    
    func assignmentCreation(_: UIAlertAction)
    {
        let alert = UIAlertController(title: "Enter Assignment", message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler:
            {   _ in
                if let assignment = alert.textFields?[0].text
                {
                    let assignmentsForFirebase = ["Assignment1" : assignment]
                    
                    let mySet = ref.child("Users/\(self.uidTemp)/Teacher/ClassNumber\(self.classNumberFromPrevious)/Assignments")
                    mySet.updateChildValues(assignmentsForFirebase)
                    
                    ref.child("Users/\(self.uidTemp)/Teacher/ClassNumber\(self.classNumberFromPrevious)/Assignments").observeSingleEvent(of: .value, with: { (snapshot) in
                    
                        if let dictionary = snapshot.value as? [String: AnyObject]
                        {
                            let number = dictionary.count + 1
                            let assignmentsForFirebase = ["Assignment\(number)" : assignment]
                            
                            let mySet = ref.child("Users/\(self.uidTemp)/Teacher/Assignments")
                            mySet.updateChildValues(assignmentsForFirebase)
                        }
                        
                }, withCancel: nil)
                    
                }
                else
                {
                    let failure = UIAlertController(title: "Failed", message: nil, preferredStyle: .alert)
                    failure.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(failure, animated: true, completion: nil)
                }
        }))
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return studentsInClass.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = teacherDetailTableView.dequeueReusableCell(withIdentifier: "StudentsShow", for: indexPath)
        
        let showTheStudents = studentsInClass[indexPath.row]
        
        cell.textLabel?.text = showTheStudents
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }

}
