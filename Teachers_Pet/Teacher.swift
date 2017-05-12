//
//  Teacher.swift
//  Teachers_Pet
//
//  Created by nmalin-jones on 4/9/17.
//  Copyright © 2017 nmalin-jones. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import ChameleonFramework

class Teacher: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    var uidTemp = String()
    var teacherName = String()
    var allStudents = [String]()
    var onlineStatus = [String]()
    var classesTable = [String]()
    var numberTracker = 1
    var codesFromClass = [String]()
    
    @IBOutlet weak var teacherTableView: UITableView!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        let uid = FIRAuth.auth()?.currentUser?.uid
        uidTemp = uid!
        grabData()
    }
    
    func grabData()
    {
        ref.child("Users/\(uidTemp)/Teacher/").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject]
            {
                let teacherNamefromFireBase = dictionary["Teacher Name"] as? String
                
                self.teacherName = teacherNamefromFireBase!
            }
            
        }, withCancel: nil)
        
        ref.child("Users/\(uidTemp)/Teacher/").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject]
            {
                self.numberTracker = (dictionary.count)
                print(self.numberTracker - 3)
            }
            
        }, withCancel: nil)
        
        
        loopGrab(loopStart: 1, loopEnd: 100)

    }
    
    func loopGrab(loopStart : Int, loopEnd : Int)
    {
        for number in loopStart...loopEnd
        {
            ref.child("Users/\(self.uidTemp)/Teacher/ClassName\(number)").observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject]
                {
                    let className = dictionary["ClassName"] as! String
                    let codes = dictionary["ClassCode"] as! String
                    self.classesTable.append(className)
                    self.codesFromClass.append(codes)
                    self.teacherTableView.reloadData()
                }
            }, withCancel: nil)
        }
    }
    
    @IBAction func teacheraddButtonPressed(_ sender: Any)
    {
        let actions = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actions.addAction(UIAlertAction(title: "Create a New Class", style: .default, handler: classCreation))
        actions.addAction(cancelAction)
        present(actions, animated: true, completion: nil)
    }

    func classCreation(_: UIAlertAction)
    {
        let alert = UIAlertController(title: "Enter a Name:", message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler:
            {   _ in
                if let className = alert.textFields?[0].text
                {
                    let thatCode = randomCode
                    
                    let classCreate = ["ClassName" : className, "ClassCode" : thatCode]
                    let teacherCodeInfo = ["Class Name": className, "Teacher" : self.teacherName, "Uses" : "20", "Teacher ID" : "\(self.uidTemp)", "CodeNumber" : (self.numberTracker - 3)] as [String : Any]
                    
                    let myRefTeach = ref.child("Users/\(self.uidTemp)/Teacher/ClassName\(self.numberTracker - 3)")
                    myRefTeach.updateChildValues(classCreate)
                    set(teacherCodeInfo, forKey: "Users/Class Codes/\(thatCode)")
                    
                    self.loopGrab(loopStart: (self.numberTracker - 3), loopEnd: 100)
                    self.teacherTableView.reloadData()
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
        return classesTable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = teacherTableView.dequeueReusableCell(withIdentifier: "Teacher", for: indexPath)
        
        let classes = classesTable[indexPath.row]
        let showTheCodes = codesFromClass[indexPath.row]
        
        cell.textLabel?.text = classes
        cell.detailTextLabel?.text = showTheCodes
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let teacherClassMenu = storyboard?.instantiateViewController(withIdentifier: "TeacherClassMainMenu") as! TeacherClassMainMenu
        let helpInfoShow = storyboard?.instantiateViewController(withIdentifier: "HelpViewTeacher") as! HelpViewTeacherViewController
        print("\(indexPath.item + 1)")
        teacherClassMenu.classNumberFromPrevious = "\(indexPath.item + 1)"
        helpInfoShow.classNumber = "\(indexPath.item + 1)"
        
        navigationController?.pushViewController(teacherClassMenu, animated: true)
    }

}
