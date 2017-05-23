//
//  StudentSideTableViewController.swift
//  Teachers_Pet
//
//  Created by nmalin-jones on 5/22/17.
//  Copyright © 2017 nmalin-jones. All rights reserved.
//

import UIKit
import SideMenu
import ChameleonFramework

class StudentSideTableViewController: UITableViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor(gradientStyle: UIGradientStyle.leftToRight, withFrame: tableView.frame, andColors: [FlatGrayDark(), FlatGray(), FlatTeal(), FlatTealDark()])
    }

}
