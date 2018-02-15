//
//  HomeworkCell.swift
//  Cranbrook
//
//  Created by Chase Norman on 2/13/18.
//  Copyright © 2018 Chase Norman. All rights reserved.
//

import Foundation
import UIKit

class HomeworkCell: UITableViewCell{
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func homework(_ homework: [String:Any]){
        if let short_description = homework["short_description"]! as? String{
            textLabel!.text = String(htmlEncodedString: short_description);
        }
        if let long_description = homework["long_description"]! as? String{
            detailTextLabel!.text = String(htmlEncodedString: long_description);
        }
    }
}
