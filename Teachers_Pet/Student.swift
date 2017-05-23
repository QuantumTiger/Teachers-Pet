//
//  Student.swift
//  Teachers_Pet
//
//  Created by Student on 4/19/17.
//  Copyright © 2017 nmalin-jones. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import ChameleonFramework
//jdfklast

class Student: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var studentTableView: UITableView!
    
    var uidTemp = String()
    var studentName = String()
    var teacherTable = [String]()
    var classesTable = [String]()
    var numberOfStudents = 1
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let uid = FIRAuth.auth()?.currentUser?.uid
        uidTemp = uid!
        grabData()
    }
    
    func grabData()
    {
        ref.child("Users/\(uidTemp)/Student/Classes Enrolled/").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject]
            {
                let numberTracker = (dictionary.count)
                print(numberTracker)
                
                for number in 1...numberTracker
                {
                    ref.child("Users/\(self.uidTemp)/Student/Classes Enrolled/ClassName\(number)").observeSingleEvent(of: .value, with: { (snapshot) in
                        if let dictionary = snapshot.value as? [String: AnyObject]
                        {
                            let className = dictionary["ClassName"] as! String
                            self.classesTable.append(className)
                            let teacherName = dictionary["TeacherName"] as! String
                            self.teacherTable.append(teacherName)
                            
                            self.studentTableView.reloadData()
                        }
                        
                    }, withCancel: nil)
                }
            }
            
        }, withCancel: nil)
        
        ref.child("Users/\(uidTemp)/Student/").observeSingleEvent(of: .value, with: { (snapshot) in
    
            if let dictionary = snapshot.value as? [String: AnyObject]
            {
                let studentNamefromFireBase = dictionary["Student Name"] as? String
                    
                self.studentName = studentNamefromFireBase!
            }
            
        }, withCancel: nil)
        
    }
    
    @IBAction func plusButtonTapped(_ sender: Any)
    {
        let actions = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actions.addAction(UIAlertAction(title: "Enter a Class Code", style: .default, handler: enterTheClassCode))
        actions.addAction(cancelAction)
        present(actions, animated: true, completion: nil)
    }
    
    func lookAtTeacherWithCount(teacherID : String, codeNumber : Int)
    {
        ref.child("Users/\(teacherID)/Teacher/ClassName\(codeNumber)/Students Enrolled").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject]
            {
                print("Number of Students: \(dictionary.count)")
                self.numberOfStudents = dictionary.count
            }
            
//        let myRefTeach = ref.child("Users/\(teacherID)/Teacher/ClassName\(codeNumber)/Students Enrolled/")
//        myRefTeach.updateChildValues(studentNameAdd)
            
        }, withCancel: nil)
    }

    func enterTheClassCode(_: UIAlertAction)
    {
        let alert = UIAlertController(title: "Enter a code:", message: "(case sensitive)", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Use Code", style: .default, handler:
            {   _ in
                if let code = alert.textFields?[0].text
                {
                    ref.child("Users/Class Codes/\(code)").observeSingleEvent(of: .value, with: { (snapshot) in
                        
                        if let dictionary = snapshot.value as? [String: AnyObject]
                        {
                            let className = dictionary["Class Name"] as! String
                            let teacher = dictionary["Teacher"] as! String
                            let teacherID = dictionary["Teacher ID"] as! String
                            let codeNumber = dictionary["CodeNumber"] as! Int
                            //let uses = dictionary["Uses"] as? String
                            
                            self.teacherTable.append(teacher)
                            self.classesTable.append(className)
                            self.studentTableView.reloadData()
                            
                            
                            self.lookAtTeacherWithCount(teacherID: teacherID, codeNumber: codeNumber)

                            let classesDetail = ["ClassName" : className, "TeacherName" : teacher, "TeacherID" : teacherID]
                            let studentNameAdd = ["StudentName\(self.numberOfStudents + 1)" : self.studentName]
                            
                            ref.child("Users/\(self.uidTemp)/Student/Classes Enrolled/").observeSingleEvent(of: .value, with: { (snapshot) in
                                
                                if let dictionary = snapshot.value as? [String: AnyObject]
                                {
                                    let numberTracker = (dictionary.count)
                                    print(numberTracker)
                                    
                                    let myRef = ref.child("Users/\(self.uidTemp)/Student/Classes Enrolled/ClassName\(numberTracker + 1)")
                                    myRef.updateChildValues(classesDetail)
                                    let myRefTeach = ref.child("Users/\(teacherID)/Teacher/ClassName\(codeNumber)/Students Enrolled/")
                                    myRefTeach.updateChildValues(studentNameAdd)
                                    
                                }
                                
                            }, withCancel: nil)
                        }
                        
                    }, withCancel: nil)
                    
//                let success = UIAlertController(title: "Class Activated!", message: "You Successfully Joined a class", preferredStyle: .alert)
//                success.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
//                self.present(success, animated: true, completion: nil)
                    
                }
                else
                {
                    let failure = UIAlertController(title: "Invalid Class Code", message: nil, preferredStyle: .alert)
                    failure.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(failure, animated: true, completion: nil)
                }
        }))
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return teacherTable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = studentTableView.dequeueReusableCell(withIdentifier: "Student", for: indexPath)
        
        let classes = classesTable[indexPath.row]
        let teachers = teacherTable[indexPath.row]
        
        cell.textLabel?.text = classes
        cell.detailTextLabel?.text = teachers
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let studentClassMainMenu = storyboard?.instantiateViewController(withIdentifier: "assignmentTable") as! StudentClassMainMenu
        print("\(indexPath.item + 1)")
        studentClassMainMenu.classNumberSelected = "\(indexPath.item + 1)"
        
        navigationController?.pushViewController(studentClassMainMenu, animated: true)
    }
    
}
