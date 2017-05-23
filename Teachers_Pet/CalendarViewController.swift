
//
//  CalendarViewController.swift
//  Teachers_Pet
//
//  Created by Student on 5/12/17.
//  Copyright © 2017 nmalin-jones. All rights reserved.
//

import UIKit
import EPCalendarPicker
import ChameleonFramework

class CalendarViewController: UIViewController, EPCalendarPickerDelegate
{
    @IBOutlet var myView: UIView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        myView.backgroundColor = UIColor(gradientStyle: UIGradientStyle.topToBottom, withFrame: myView.frame, andColors: [FlatWhite(),FlatWhiteDark(), FlatRedDark(), FlatRed()])
    }
    
    
    @IBAction func calendar(_ sender: Any)
    {
        let calendarPicker = EPCalendarPicker(startYear: 2000, endYear: 3000, multiSelection: true, selectedDates: [])
        calendarPicker.calendarDelegate = self
        calendarPicker.startDate = Date()
        calendarPicker.hightlightsToday = true
        calendarPicker.showsTodaysButton = true
        calendarPicker.hideDaysFromOtherMonth = true
        calendarPicker.tintColor = UIColor.orange
        calendarPicker.dayDisabledTintColor = UIColor.gray
        calendarPicker.title = "Date Picker"
        calendarPicker.backgroundColor = UIColor.white
        
        
        let navigationController = UINavigationController(rootViewController: calendarPicker)
        self.present(navigationController, animated: true, completion: nil)
    }
}
