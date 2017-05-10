//
//  ViewController.swift
//  Teachers_Pet
//
//  Created by nmalin-jones on 3/22/17.
//  Copyright © 2017 nmalin-jones. All rights reserved.
// kdjflkads;fa


import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import ChameleonFramework

class ViewController: UIViewController
{
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet var myView: UIView!

    var isTeacher = true
    var numberTracker = 1
    var uidTemp = String()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        myView.backgroundColor = UIColor(gradientStyle: UIGradientStyle.topToBottom, withFrame: myView.frame, andColors: [FlatMint(),FlatMintDark(), FlatOrangeDark(), FlatOrange()])
        //loginButton.backgroundColor = UIColor(complementaryFlatColorOf: FlatOrange())
    }
    
    
    @IBAction func signUpTapped(_ sender: Any)
    {
        createUser()
        //Should prompt user to see if they are student or teacher
    }

    @IBAction func loginTapped(_ sender: Any)
    {
        loginUser()
        //Goes to the proper view controller depending on the user ID
    }
    
    func createUser()
    {
        //Checks whether if textfields are empty or not
        if emailTextField.text == "" && passwordTextField.text == "" || emailTextField.text == "" || passwordTextField.text == ""
        {
            alertViewNilHandler("Error", "Please enter your email and password")
        }

        else
        {
            FIRAuth.auth()?.createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                
                if error == nil
                {
                    print("You have successfully signed up")
                    //Goes to the Setup page which lets the user take a photo for their profile picture and also chose a username
                    guard let uid = user?.uid else {return}
                    self.uidTemp = uid
                    self.alertUICreate()
                }
                    
                //Problem with entering something into the email text gives an error
                else
                {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    func checkIfUserIsLoggedIn()
    {
        if FIRAuth.auth()?.currentUser?.uid == nil
        {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }
        else
        {
            let uid = FIRAuth.auth()?.currentUser?.uid
            
            FIRDatabase.database().reference().child("Users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                //print(snapshot)
                
                
                if let dictionary = snapshot.value as? [String: AnyObject]
                {
                    let userCheck = dictionary["StudentORTeacher"] as? String
                    
                    if userCheck == "Teacher"
                    {
                        self.goToController(storyboardName: "Teacher")
                    }
                    else if userCheck == "Student"
                    {
                        self.goToController(storyboardName: "Student")
                    }
                }
                
                
            }, withCancel: nil)
        }
    }
    
    func handleLogout()
    {
        do
        {
            try FIRAuth.auth()?.signOut()
        }
        catch let logoutError
        {
            print(logoutError)
        }
    }
    
    func loginUser()
    {
        if self.emailTextField.text! == "" || self.passwordTextField.text! == "" || self.emailTextField.text! == "" && self.passwordTextField.text! == ""
        {
            //Alert to tell the user that there was an error because they didn't fill anything in the textfields because they didn't fill anything in
            
            alertViewNilHandler("Error", "Please enter an email and password.")
        }
        else
        {
            FIRAuth.auth()?.signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (user, error) in
                
                if error == nil
                {
                    //Print into the console if successfully logged in
                    print("You have successfully logged in")
                    self.checkIfUserIsLoggedIn()
                }
                else
                {
                    //Tells the user that there is an error and then gets firebase to tell them the error
                    self.alertViewNilHandler("Error", (error?.localizedDescription)!)
                }
            }
        }
    }
    
    func alertUICreate()
    {
        //Creates the alert for first time users
        let actions = UIAlertController(title: "Are you a...", message: nil, preferredStyle: .actionSheet)
        actions.addAction(UIAlertAction(title: "Student", style: .default, handler: self.alertUIStudent))
        actions.addAction(UIAlertAction(title: "Teacher", style: .default, handler: self.alertUITeacher))
        actions.addAction(cancelAction)
        present(actions, animated: true, completion: nil)
    }
    
    func alertUIStudent(_ : UIAlertAction)
    {
        //Configures text fields for student after proccess is done it should go to student view controller
        let alert = UIAlertController(title: "Configure", message: nil, preferredStyle: .alert)
        alert.addTextField
            { (field) in
                field.autocapitalizationType = .words
                field.placeholder = "Your Name"
        }
        alert.addTextField
            { (field) in
            field.autocapitalizationType = .words
            field.placeholder = "Class Code"
        }
        

        alert.addAction(UIAlertAction(title: "Done", style: .default, handler:
            {   _ in
                
                if (alert.textFields?[0].text)! == ""
                {
                    let alertController = UIAlertController(title: "Error", message: "Please Enter a Name", preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: self.alertUITeacher)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
                else if (alert.textFields?[1].text)! == ""
                {
                    let alertController = UIAlertController(title: "Error", message: "Please Enter a Class Code", preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: self.alertUITeacher)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
                else
                {
                    self.addUserToFirebase((alert.textFields?[0].text)!, (alert.textFields?[1].text)!, "Student")
                }
        }))
        present(alert, animated: true, completion: nil)
        
    }
    
    func alertUITeacher(_ : UIAlertAction)
    {
        //Sets up teacher, adds them to firebase
        let alert = UIAlertController(title: "Setup your Class", message: nil, preferredStyle: .alert)
        alert.addTextField
            { (field) in
                field.autocapitalizationType = .words
                field.placeholder = "Your Name"
        }
        alert.addTextField
            { (field) in
                field.autocapitalizationType = .words
                field.placeholder = "Name of Class"
        }
        
        //Gathers information and puts to firebase and also checks if anything in texts
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler:
            {   _ in
                if (alert.textFields?[0].text)! == ""
                {
                    let alertController = UIAlertController(title: "Error", message: "Please Enter a Name", preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: self.alertUITeacher)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
                else if (alert.textFields?[1].text)! == ""
                {
                    let alertController = UIAlertController(title: "Error", message: "Please Enter a Class Name", preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: self.alertUITeacher)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
                
                else
                {
                    self.addUserToFirebase((alert.textFields?[0].text)!, (alert.textFields?[1].text)!, "Teacher")
                }
                
                
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func goToController(storyboardName: String)
    {
        let storyboard = UIStoryboard(name: storyboardName + "Storyboard", bundle: nil)
        let controller = storyboard.instantiateInitialViewController()
        self.present(controller!, animated: true, completion: nil)
    }

    //Add teacher or student into firebase
    func addUserToFirebase(_ yourName: String, _ classNameOrCode: String, _ studentORTeacher: String)
    {
        //Add to firebase along with name and class name all that good stuff
        
        let values = ["Email": self.emailTextField.text, "Password" : self.passwordTextField.text]
        let teacherCodeInfo = ["Class Name": classNameOrCode, "Teacher" : yourName, "Uses" : "20", "Teacher ID" : "\(self.uidTemp)", "CodeNumber" : 1] as [String : Any]
        let studentInfo = ["Student Name" : yourName, "Student ID" : "\(self.uidTemp)"]
        let teacherInfo = ["Teacher Name" : yourName, "Teacher ID" : "\(self.uidTemp)"]
        let className = ["ClassName" : classNameOrCode]
        
        if studentORTeacher == "Teacher"
        {
            set("Teacher", forKey: "Users/\(self.uidTemp)/StudentORTeacher/")
            set(teacherInfo, forKey: "Users/\(self.uidTemp)/Teacher/")
            set(className, forKey: "Users/\(self.uidTemp)/Teacher/ClassName1")
            set(values, forKey: "Users/\(self.uidTemp)/Teacher/Teacher Account/")
            set(teacherCodeInfo, forKey: "Users/Class Codes/\(randomCode)")
            
            
            //Notifies teacher that class is created and can go to their view controller
            let alert = UIAlertController(title: "Class Created", message: "Your class name is \(classNameOrCode).", preferredStyle: .alert)
            alert.addAction(dismissAction)
            present(alert, animated: true, completion: nil)
        }
        else if studentORTeacher == "Student"
        {
            set("Student", forKey: "Users/\(self.uidTemp)/StudentORTeacher/")
            set(studentInfo, forKey: "Users/\(self.uidTemp)/Student/")
            set(values, forKey: "Users/\(self.uidTemp)/Student/Student Account")
            
            
            ref.child("Users/Class Codes/\(classNameOrCode)").observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject]
                {
                    let className = dictionary["Class Name"] as! String
                    let codeNumber = dictionary["Code Number"] as! String
                    let teacher = dictionary["Teacher"] as! String
                    let teacherID = dictionary["Teacher ID"] as! String
                    let uses = dictionary["Uses"] as? String
                
                    ref.child("Users/\(teacherID)/Teacher/ClassName\(codeNumber)/Students Enrolled").observeSingleEvent(of: .value, with: { (snapshot) in
                        
                        if let dictionary = snapshot.value as? [String: AnyObject]
                        {
                            let studentCount = (dictionary.count + 1)
                            
                            let classesDetail = ["TeacherName" : teacher, "ClassName" : className, "TeacherID" : teacherID]
                            //let studentEnrolled = ["Student Name" : yourName, "Student ID" : self.uidTemp]
                            
                            set(classesDetail, forKey: "Users/\(self.uidTemp)/Student/Classes Enrolled/ClassName1")
                            set(className, forKey: "Users/\(teacherID)/Teacher/ClassName\(codeNumber)/ClassName")
                            set(yourName, forKey: "Users/\(teacherID)/Teacher/ClassName\(codeNumber)/Students Enrolled/StudentName\(studentCount)")
                        }
                        
                    }, withCancel: nil)
                }
                
                
            }, withCancel: nil)
            
            //                    let success = UIAlertController(title: "Class Activated!", message: "You Successfully Joined a class", preferredStyle: .alert)
            //                    self.present(success, animated: true, completion: nil)
            
        }
        else
        {
            let failure = UIAlertController(title: "Invalid Class Code", message: nil, preferredStyle: .alert)
            failure.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(failure, animated: true, completion: nil)
        }
    
    }

    func alertViewNilHandler(_ title: String, _ message: String)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler : nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }

   
}
