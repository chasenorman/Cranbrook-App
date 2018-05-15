//
//  ScheduleCell.swift
//  Cranbrook
//
//  Created by Aziz Zaynutdinov on 5/15/18.
//  Copyright © 2018 Chase Norman. All rights reserved.
//

import Foundation
import UIKit

class ScheduleCell: UITableViewCell{
    func schedule(_ schedule: Schedule){
        textLabel!.text = String(htmlEncodedString: schedule.CourseTitle)
        detailTextLabel!.text = String(htmlEncodedString: schedule.MyDayStartTime + "-" + schedule.MyDayEndTime)
        let endIndex = textLabel!.text?.index((textLabel!.text?.endIndex)!, offsetBy: -3)
        var truncated = textLabel!.text?.substring(to: endIndex!)
        textLabel!.text = truncated
    }
}

