

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
        super.viewDidLoad()
        let uid = FIRAuth.auth()?.currentUser?.uid
        uidTemp = uid!
        print(teacherID)
        print(className)
        grabData()
        
        navigationController?.isNavigationBarHidden = true
    }
    
    func grabData()
    {
        ref.child("Users/\(teacherID)/Teacher/\(className)/Assignments/").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject]
            {
                let numberTracker = (dictionary.count)
                print(dictionary.count)
                
                for number in 1...numberTracker
                {
                    let assignmentsShow = dictionary["Assignment1"] as! String
                    self.assignmentsArray.append(assignmentsShow)
                    self.assignmentsTableView.reloadData()
                }
            }
            
        }, withCancel: nil)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return assignmentsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = assignmentsTableView.dequeueReusableCell(withIdentifier: "assignmentsCell", for: indexPath)
        
        let assignments = assignmentsArray[indexPath.row]
        
        cell.textLabel?.text = assignments
        
        return cell
    }
    
    
    
    
    
    
}
