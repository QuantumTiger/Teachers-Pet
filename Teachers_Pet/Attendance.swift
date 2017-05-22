//
//  Attendance.swift
//  Teachers_Pet
//
//  Created by WGonzalez on 5/21/17.
//  Copyright © 2017 nmalin-jones. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class Attendance: UIViewController
{

    @IBOutlet weak var attendanceTableView: UITableView!
    
    var uidTemp = String()
    var attendance = [String]()
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let uid = FIRAuth.auth()?.currentUser?.uid
        uidTemp = uid!
        
        // Do any additional setup after loading the view.
    }
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
//    {
//        <#code#>
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
//    {
//        <#code#>
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
//    {
//        var green = false
//        var red = false
//        var yellow = false
//    
//        
//        
//        
//    }
    

}
