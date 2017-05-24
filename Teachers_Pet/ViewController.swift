//
//  ViewController.swift
//  Teachers_Pet
//
//  Created by nmalin-jones on 3/22/17.
//  Copyright © 2017 nmalin-jones. All rights reserved.



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
    @IBOutlet weak var myAccountView: UIView!

    var numberTracker = 1
    var uidTemp = String()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //Changes the background of the view
        myView.backgroundColor = UIColor(gradientStyle: UIGradientStyle.topToBottom, withFrame: myView.frame, andColors: [FlatMint(),FlatMintDark(), FlatOrangeDark(), FlatOrange()])
        
        //secures the password and creates it in dots
        passwordTextField.isSecureTextEntry = true
        
        //rounds the corners of the view
        myAccountView.layer.cornerRadius = 5
        loginButton.layer.cornerRadius = 5
        
        //sublayers clipped to main layer
        loginButton.layer.masksToBounds = true
        myAccountView.layer.masksToBounds = true
        
    }
    
    
    @IBAction func signUpTapped(_ sender: Any)
    {
        //Should prompt user to see if they are student or teacher
        createUser()
        
    }

    @IBAction func loginTapped(_ sender: Any)
    {
        //Goes to the proper view controller depending on the user ID
        loginUser()
    }
    
    func createUser()
    {
        //Checks whether if textfields are empty or not
        if emailTextField.text == "" && passwordTextField.text == "" || emailTextField.text == "" || passwordTextField.text == ""
        {
            //Pops up alertview if there are errors
            alertViewNilHandler("Error", "Please enter your email and password")
                    }

        else
        {
            //creates a user through firebase
            FIRAuth.auth()?.createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                
                //if there is no error the signup was successful
                if error == nil
                {
                    print("You have successfully signed up")
                    
                    //gets the user ID
                    guard let uid = user?.uid else {return}
                    self.uidTemp = uid
                    
                    //Creates the user
                    self.alertUICreate()
                }
                    
                //Problem with entering something into the email text gives an error
                else
                {
                    //problem with creating user alertview shows up with error
                    let alert = SCLAlertView()
                    alert.showError("Error", subTitle: (error?.localizedDescription)!)
                }
            }
        }
    }
    
    //checks if the user is logged in
    func checkIfUserIsLoggedIn()
    {
        //checks if the person is out of he app
        if FIRAuth.auth()?.currentUser?.uid == nil
        {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }
        else
        {
            //gets id of person logging in
            let uid = FIRAuth.auth()?.currentUser?.uid
            
            //checks for the users
            FIRDatabase.database().reference().child("Users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                
                //checks for the values in the firebase database
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
    
    //logs user out of firebase
    func handleLogout()
    {
        do
        {
            //signs out user
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
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        //Creates the alert for first time users
        let alert = SCLAlertView(appearance: appearance)
        
        alert.addButton("Student") { 
            self.alertUIStudent()
        }
        alert.addButton("Teacher") { 
            self.alertUITeacher()
        }
        alert.addButton("Cancel") { 
            alert.dismiss(animated: true, completion: nil)
        }
        alert.showEdit("Are you a...", subTitle: "")
        
    }
    
    func alertUIStudent()
    {
        //Configures text fields for student after proccess is done it should go to student view controller
        
        let appearence = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        
        
        // Initialize SCLAlertView using custom Appearance
        let alert = SCLAlertView(appearance: appearence)
        
        // Creates the subview
        let subview = UIView(frame: CGRect(x: 0,y: 0,width: 216,height: 70))
        let x = (subview.frame.width - 180) / 2

        
        //sets properties for the textfield
        let textFieldName = UITextField(frame: CGRect(x: x,y: 10,width: 180,height: 25))
        textFieldName.layer.borderColor = UIColor.blue.cgColor
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
        
        //adds actions to button
        alert.customSubview = subview
        _ = alert.addButton("Sign up")
        {
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
            //GO TO CONTROLLER HERE
            self.goToController(storyboardName: "Student")
        }
        _ = alert.addButton("Back", action: {
            alert.dismiss(animated: true, completion: nil)
            self.alertUICreate()
        })
        

        alert.showEdit("", subTitle: "")
        
    }
    
    func alertUITeacher()
    {
        //Configures text fields for student after proccess is done it should go to student view controller
        
        let appearence = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        
        // Initialize SCLAlertView using custom Appearance
        let alert = SCLAlertView(appearance: appearence)
        
        // Creat the subview
        let subview = UIView(frame: CGRect(x: 0,y: 0,width: 216,height: 70))
        let x = (subview.frame.width - 180) / 2
        
        //sets properties for the textfields
        let textFieldName = UITextField(frame: CGRect(x: x,y: 10,width: 180,height: 25))
        textFieldName.layer.borderColor = UIColor.blue.cgColor
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
        
        //sets the actions for the buttons
        alert.customSubview = subview
        _ = alert.addButton("Sign Up") {
            print("Sign Up")
            if textFieldName.text == "" {
                let alertError = SCLAlertView()
                alertError.showError("Error", subTitle: "Please enter a name")
            } else if textFieldClassName.text == "" {
                let alertError = SCLAlertView()
                alertError.showError("Error", subTitle: "Please Enter a Class Name")
            } else {
                self.addUserToFirebase(textFieldName.text!, textFieldClassName.text!, "Teacher")
            }

            //GO TO CONTROLLER HERE
            self.goToController(storyboardName: "Teacher")
        }
        _ = alert.addButton("Back", action: {
            alert.dismiss(animated: true, completion: nil)
            self.alertUICreate()
        })
        
        
        alert.showEdit("", subTitle: "")
    }
    
    func goToController(storyboardName: String)
    {
        //swtiches storyboards
        let storyboard = UIStoryboard(name: storyboardName + "Storyboard", bundle: nil)
        let controller = storyboard.instantiateInitialViewController()
        self.present(controller!, animated: true, completion: nil)
    }

    //Add teacher or student into firebase
    func addUserToFirebase(_ yourName: String, _ classNameOrCode: String, _ studentORTeacher: String)
    {
        //Add to firebase along with name and class name all that good stuff
        
        let thatCode = randomCode
        
        let values = ["Email": self.emailTextField.text, "Password" : self.passwordTextField.text]
        let teacherCodeInfo = ["Class Name": classNameOrCode, "Teacher" : yourName, "Uses" : "20", "Teacher ID" : "\(self.uidTemp)", "CodeNumber" : 1, "ClassCode" : thatCode] as [String : Any]
        let studentInfo = ["Student Name" : yourName, "Student ID" : "\(self.uidTemp)"]
        let teacherInfo = ["Class Name": className, "Teacher" : self.teacherName, "Teacher ID" : "\(self.uidTemp)", "ClassCode" : thatCode, "CodeNumber" : "ClassName1"] as [String : Any]
        let className = ["ClassName" : classNameOrCode, "ClassCode" : thatCode]
        
        if studentORTeacher == "Teacher"
        {
            set("Teacher", forKey: "Users/\(self.uidTemp)/StudentORTeacher/")
            set(teacheInfo, forKey: "Users/\(self.uidTemp)/Teacher/")
            set(className, forKey: "Users/\(self.uidTemp)/Teacher/ClassName1")
            set(values, forKey: "Users/\(self.uidTemp)/Teacher/Teacher Account/")
            set(teacherCodeInfo, forKey: "Users/Class Codes/\(thatCode)")
            
            
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
                    let codeNumber = dictionary["CodeNumber"] as! Int
                    let teacher = dictionary["Teacher"] as! String
                    let teacherID = dictionary["Teacher ID"] as! String
                    let uses = dictionary["Uses"] as? String
                
                    ref.child("Users/\(teacherID)/Teacher/ClassName\(codeNumber)/Students Enrolled").observeSingleEvent(of: .value, with: { (snapshot) in
                        
                        if let dictionary = snapshot.value as? [String: AnyObject]
                        {
                            let studentCount = (dictionary.count + 1)
                            
                            let classesDetail = ["TeacherName" : teacher, "ClassName" : className, "Teacher ID" : teacherID, "ClassNumber" : "ClassName1"]

                            //let studentEnrolled = ["Student Name" : yourName, "Student ID" : self.uidTemp]
                            
                            set(classesDetail, forKey: "Users/\(self.uidTemp)/Student/Classes Enrolled/ClassName1")
                            set(className, forKey: "Users/\(teacherID)/Teacher/ClassName\(codeNumber)/ClassName")
                            set(yourName, forKey: "Users/\(teacherID)/Teacher/ClassName\(codeNumber)/Students Enrolled/StudentName\(studentCount)")
                        }
                        
                    }, withCancel: nil)
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
        //error

        let alert = SCLAlertView()
        alert.showError(title, subTitle: message)
    }

   
}
