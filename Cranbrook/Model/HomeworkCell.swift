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
    
    func homework(_ homework: Homework){
        detailTextLabel!.text = "";
        textLabel!.text = String(htmlEncodedString: homework.short_description);
        if let l = homework.long_description{
            detailTextLabel!.text = String(htmlEncodedString: l);
        }
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
