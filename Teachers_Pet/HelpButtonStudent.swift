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
import ChameleonFramework

class HelpButtonStudent: UIViewController
{
    
    @IBOutlet var myView: UIView!
    @IBOutlet var helpButton: UIImageView!
    var uidTemp = String()
    var studentName = String()
    var teacherID = String()
    var classCounter = Int()
    var storeTheNames = [String]()
    
    override func viewDidLoad()
    {
        //Retrieves basic data to operate the app
        super.viewDidLoad()
        helpButton.isUserInteractionEnabled = true
        let uid = FIRAuth.auth()?.currentUser?.uid
        uidTemp = uid!
        grabData()
        myView.backgroundColor = UIColor(gradientStyle: UIGradientStyle.radial, withFrame: myView.frame, andColors: [FlatOrange(),FlatOrangeDark(), FlatLimeDark(), FlatLime()])
    }

    func grabData()
    {
        ref.child("Users/\(uidTemp)/Student/Classes Enrolled").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject]
            {
                self.classCounter = (dictionary.count)
                //Looks at the snapshot so that it can retreive data
                ref.child("Users/\(self.uidTemp)/Student/Classes Enrolled/ClassName\(self.classCounter)").observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    if let dictionary = snapshot.value as? [String: AnyObject]
                    {
                        let teacherIDfromFireBase = dictionary["Teacher ID"] as! String
                        self.teacherID = teacherIDfromFireBase
                        
                        ref.child("Users/\(self.uidTemp)/Teacher/Help Section").observeSingleEvent(of: .value, with: { (snapshot) in
                            
                            if let dictionary = snapshot.value as? [String: AnyObject]
                            {
                                let studentsCount = dictionary.count
                                
                                //Gets all the data from the help section so that it can push any changes to it later
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

        //Looks at data, and sets the Student Name for pushing to firebase purposes
        ref.child("Users/\(uidTemp)/Student/").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject]
            {
                let studentNamefromFireBase = dictionary["Student Name"] as? String
                self.studentName = studentNamefromFireBase!
            }
            
        }, withCancel: nil)
    }
    
    //tap gesture for help button
    @IBAction func helpButtonPressed(_ sender: UITapGestureRecognizer)
    {
        //help button image in the image view
        self.helpButton.image = UIImage(named: "helpbuttonPressed")
        
        
        let help = ["StudentName\(classCounter)" : studentName]
        
        //When pressed it will push the student who needs help, it will go to firebase so that the teacher can see who needs help
        let myRefPush = ref.child("Users/\(teacherID)/Teacher/Help Section")
        myRefPush.updateChildValues(help)
    }
    
    //when cancel button is pressed the help button animates back  
    @IBAction func cancelButton(_ sender: Any)
    {
        print("Nothing Should Happen, too Much work for firebase code")
        self.helpButton.image = UIImage(named: "helpbutton")
//        
//        let myRefPull = ref.child("Users/\(teacherID)/Teacher/Help Section/StudentName")
        
//        updateFire(fireBaseString:  "Users/\(uidTemp)/Teacher/Help Section", array: storeTheNames)
    }
}
