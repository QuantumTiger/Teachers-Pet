//
//  TeacherSideTableViewController.swift
//  
//
//  Created by nmalin-jones on 5/22/17.
//
//

import UIKit
import SideMenu
import ChameleonFramework

class TeacherSideTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor(gradientStyle: UIGradientStyle.leftToRight, withFrame: tableView.frame, andColors: [FlatGrayDark(), FlatGray(), FlatTeal(), FlatTealDark()])
    }

}
