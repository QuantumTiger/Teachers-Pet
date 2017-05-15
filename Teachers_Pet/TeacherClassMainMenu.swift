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

}
