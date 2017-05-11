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
import SCLAlertView

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
        passwordTextField.isSecureTextEntry = true
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
                    let alert = SCLAlertView()
                    alert.showError("Error", subTitle: (error?.localizedDescription)!)
                   // self.present(alert, animated: true, completion: nil)
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
        let alert = SCLAlertView()
        
        alert.addButton("Student") { 
            self.alertUIStudent()
        }
        alert.addButton("Teacher") { 
            self.alertUITeacher()
        }
        alert.showWait("Are you a...", subTitle: "")
        //present(alert, animated: true, completion: nil)
        
    }
    
    func alertUIStudent()
    {
        //Configures text fields for student after proccess is done it should go to student view controller
        
        let appearence = SCLAlertView.SCLAppearance()
        
        // Initialize SCLAlertView using custom Appearance
        let alert = SCLAlertView(appearance: appearence)
        
        // Creat the subview
        let subview = UIView(frame: CGRect(x: 0,y: 0,width: 216,height: 70))
        let x = (subview.frame.width - 180) / 2

        
        
        let textFieldName = UITextField(frame: CGRect(x: x,y: 10,width: 180,height: 25))
        textFieldName.layer.borderColor = UIColor.green.cgColor
        textFieldName.layer.borderWidth = 1.5
        textFieldName.layer.cornerRadius = 5
        textFieldName.textAlignment = NSTextAlignment.center
        textFieldName.autocapitalizationType = .words
        textFieldName.placeholder = "Your Name"
        subview.addSubview(textFieldName)

        let textFieldClassCode = UITextField(frame: CGRect(x: x,y: textFieldName.frame.maxY + 10,width: 180,height: 25))
        textFieldClassCode.layer.borderWidth = 1.5
        textFieldClassCode.layer.cornerRadius = 5
        textFieldClassCode.layer.borderColor = UIColor.blue.cgColor
        textFieldClassCode.textAlignment = NSTextAlignment.center
        textFieldClassCode.autocapitalizationType = .words
        textFieldClassCode.placeholder = "Class Code"
        subview.addSubview(textFieldClassCode)
        
        alert.customSubview = subview
        _ = alert.addButton("Sign up") {
            print("Signed up")
            if textFieldName.text == "" {
                let alertError = SCLAlertView()
                alertError.showError("Error", subTitle: "Please enter a name")
                self.present(alertError, animated: true, completion: nil)
            } else if textFieldClassCode.text == "" {
                let alertError = SCLAlertView()
                alertError.showError("Error", subTitle: "Please Enter a Class Code")
                self.present(alertError, animated: true, completion: nil)
            } else {
                self.addUserToFirebase(textFieldName.text!, textFieldClassCode.text!, "Student")
            }
        }
        

        alert.showWait("", subTitle: "")
        
    }
    
    func alertUITeacher()
    {
        //Configures text fields for student after proccess is done it should go to student view controller
        
        let appearence = SCLAlertView.SCLAppearance()
        
        // Initialize SCLAlertView using custom Appearance
        let alert = SCLAlertView(appearance: appearence)
        
        // Creat the subview
        let subview = UIView(frame: CGRect(x: 0,y: 0,width: 216,height: 70))
        let x = (subview.frame.width - 180) / 2
        
        
        
        let textFieldName = UITextField(frame: CGRect(x: x,y: 10,width: 180,height: 25))
        textFieldName.layer.borderColor = UIColor.green.cgColor
        textFieldName.layer.borderWidth = 1.5
        textFieldName.layer.cornerRadius = 5
        textFieldName.textAlignment = NSTextAlignment.center
        textFieldName.autocapitalizationType = .words
        textFieldName.placeholder = "Your Name"
        subview.addSubview(textFieldName)
        
        let textFieldClassName = UITextField(frame: CGRect(x: x,y: textFieldName.frame.maxY + 10,width: 180,height: 25))
        textFieldClassName.layer.borderWidth = 1.5
        textFieldClassName.layer.cornerRadius = 5
        textFieldClassName.layer.borderColor = UIColor.blue.cgColor
        textFieldClassName.textAlignment = NSTextAlignment.center
        textFieldClassName.autocapitalizationType = .words
        textFieldClassName.placeholder = "Class Name"
        subview.addSubview(textFieldClassName)
        
        alert.customSubview = subview
        _ = alert.addButton("Login") {
            print("Login")
            if textFieldName.text == "" {
                let alertError = SCLAlertView()
                alertError.showError("Error", subTitle: "Please enter a name")
                self.present(alertError, animated: true, completion: nil)
            } else if textFieldClassName.text == "" {
                let alertError = SCLAlertView()
                alertError.showError("Error", subTitle: "Please Enter a Class Name")
                self.present(alertError, animated: true, completion: nil)
            } else {
                self.addUserToFirebase(textFieldName.text!, textFieldClassName.text!, "Teacher")
            }
        }
        
        
        alert.showWait("", subTitle: "")    }
    
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
            let alert = SCLAlertView()
            alert.showSuccess("Class Created", subTitle: "Your class name is \(classNameOrCode)")
            

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
                    let teacher = dictionary["Teacher"] as! String
                    let teacherID = dictionary["Teacher ID"] as! String
                    let uses = dictionary["Uses"] as? String
                    
                    
                    let classesDetail = ["TeacherName" : teacher, "ClassName" : className, "TeacherID" : teacherID]
                    //let studentEnrolled = ["Student Name" : yourName, "Student ID" : self.uidTemp]
                    
                    set(classesDetail, forKey: "Users/\(self.uidTemp)/Student/Classes Enrolled/ClassName1")
                    set(className, forKey: "Users/\(teacherID)/Teacher/ClassName1/ClassName")
                    set(yourName, forKey: "Users/\(teacherID)/Teacher/ClassName1/Students Enrolled/StudentName1")
                }
                
                
            }, withCancel: nil)
            
        }
        else
        {
            let failure = SCLAlertView()
            failure.showWarning("Invalid Class Code", subTitle: "")
            
        }
    
    }

    func alertViewNilHandler(_ title: String, _ message: String)
    {
        let alert = SCLAlertView()
        alert.showError(title, subTitle: message)
     
        
    }

   
}
