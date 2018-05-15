//
//  HomeworkCell.swift
//  Cranbrook
//
//  Created by Chase Norman on 2/13/18.
//  Edited by Aziz Zaynutdinov.
//  Copyright © 2018 Chase Norman. All rights reserved.
//

import Foundation
import UIKit

class HomeworkCell: UITableViewCell{
    func homework(_ homework: Homework){
        //This part is created by me,
        detailTextLabel!.text = String(htmlEncodedString: homework.short_description);
        textLabel!.text = String(htmlEncodedString: homework.groupname);
        let endIndex = textLabel!.text?.index((textLabel!.text?.endIndex)!, offsetBy: -3)
        var truncated = textLabel!.text?.substring(to: endIndex!)
        textLabel!.text = truncated
        //right until this point.
    }
}

extension String {
    init?(htmlEncodedString: String) {
        guard let data = htmlEncodedString.data(using: .utf8) else {
            return nil
        }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            NSAttributedString.DocumentReadingOptionKey.documentType : NSAttributedString.DocumentType.html,
            NSAttributedString.DocumentReadingOptionKey.characterEncoding : String.Encoding.utf8.rawValue
        ]
        
        if let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil){
            self.init(attributedString.string)
        }
        else {
            return nil
        }
    }
}

