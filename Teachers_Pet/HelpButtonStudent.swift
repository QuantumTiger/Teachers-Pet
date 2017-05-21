//
//  HelpButtonStudent.swift
//  Teachers_Pet
//
//  Created by Student on 5/3/17.
//  Copyright © 2017 nmalin-jones. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class HelpButtonStudent: UIViewController
{
    
    @IBOutlet var helpButton: UIImageView!
    var uidTemp = String()
    var studentName = String()
    var teacherID = String()
    var classCounter = Int()
    var storeTheNames = [String]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        helpButton.isUserInteractionEnabled = true
        let uid = FIRAuth.auth()?.currentUser?.uid
        uidTemp = uid!
        grabData()
    }

    func grabData()
    {
        ref.child("Users/\(uidTemp)/Student/Classes Enrolled").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject]
            {
                self.classCounter = (dictionary.count)
                
                ref.child("Users/\(self.uidTemp)/Student/Classes Enrolled/ClassName\(self.classCounter)").observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    if let dictionary = snapshot.value as? [String: AnyObject]
                    {
                        let teacherIDfromFireBase = dictionary["TeacherID"] as! String
                        self.teacherID = teacherIDfromFireBase
                        
                        ref.child("Users/\(self.uidTemp)/Teacher/Help Section").observeSingleEvent(of: .value, with: { (snapshot) in
                            
                            if let dictionary = snapshot.value as? [String: AnyObject]
                            {
                                let studentsCount = dictionary.count
                                
                                for number in 1...studentsCount
                                {
                                    let studentsShow = dictionary["StudentName\(number)"] as! String
                                    self.storeTheNames.append(studentsShow)
                                }
                            }
                            
                        }, withCancel: nil)
                        
                    }
                    
                }, withCancel: nil)
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
    
    @IBAction func helpButtonPressed(_ sender: UITapGestureRecognizer)
    {
        self.helpButton.image = UIImage(named: "helpbuttonPressed")
        
        let help = ["StudentName\(classCounter)" : studentName]
        
        let myRefPush = ref.child("Users/\(teacherID)/Teacher/Help Section")
        myRefPush.updateChildValues(help)
    }
    
    @IBAction func cancelButton(_ sender: Any)
    {
        print("Nothing Should Happen, too Much work for firebase code")
        self.helpButton.image = UIImage(named: "helpbutton")
//        
//        let myRefPull = ref.child("Users/\(teacherID)/Teacher/Help Section/StudentName")
        
//        updateFire(fireBaseString:  "Users/\(uidTemp)/Teacher/Help Section", array: storeTheNames)
    }
}
