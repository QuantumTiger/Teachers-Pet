

import UIKit
import SideMenu
import Firebase
import FirebaseAuth
import FirebaseDatabase

class StudentClassMainMenu: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var assignmentsTableView: UITableView!
    
    var uidTemp = String()
    var assignmentsArray = [String]()
    var className = String()
    var teacherID = String()
    var teacherName = String()
    
    override func viewDidLoad()
    {
        //Basic retrieval of data
        super.viewDidLoad()
        let uid = FIRAuth.auth()?.currentUser?.uid
        uidTemp = uid!
//        print(teacherID)
//        print(className)
        grabData()
        
        navigationController?.isNavigationBarHidden = true
    }
    
    //grabs the assignment name the teacher types in the table view from firebase
    func grabData()
    {
        ref.child("Users/\(teacherID)/Teacher/\(className)/Assignments/").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject]
            {
                let numberTracker = (dictionary.count)

                for number in 1...numberTracker
                {
                    let assignmentsShow = dictionary["Assignment\(number)"] as! String
                    self.assignmentsArray.append(assignmentsShow)
                    self.assignmentsTableView.reloadData()
                }
                
            }
            
        }, withCancel: nil)
    }
    
    
    //number of assignments in the table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return assignmentsArray.count
    }
    
    //shows up the asssignment name in the table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = assignmentsTableView.dequeueReusableCell(withIdentifier: "assignmentsCell", for: indexPath)
        
        let assignments = assignmentsArray[indexPath.row]
        
        cell.textLabel?.text = assignments
        
        return cell
    }
    
    @IBAction func refreshTapped(_ sender: Any)
    {
        assignmentsTableView.reloadData()
    }
    
    
    
    
    
    
}
