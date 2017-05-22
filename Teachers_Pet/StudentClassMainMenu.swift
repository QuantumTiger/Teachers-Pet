

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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let uid = FIRAuth.auth()?.currentUser?.uid
        uidTemp = uid!
        
        navigationController?.isNavigationBarHidden = true
    }
    
    func grabData()
    {
        
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
