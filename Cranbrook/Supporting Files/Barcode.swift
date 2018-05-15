//
//  Barcode.swift
//  Cranbrook
//
//  Created by Chase Norman on 2/21/18.
//  Copyright © 2018 Chase Norman. All rights reserved.
//

import Foundation
import UIKit

class BarcodeView: UIView{
    let barcodes : [Character : String] = ["0":"bwbWBwBwb", "1":"BwbWbwbwB", "2":"bwBWbwbwB", "3":"BwBWbwbwb", "4":"bwbWBwbwB", "5":"BwbWBwbwb", "6":"bwBWBwbwb", "7":"bwbWbwBwB", "8":"BwbWbwBwb", "9":"bwBWbwBwb", "*":"bWbwBwBwb"]
    
    override func draw(_ rect: CGRect) {
        print("Drawing...")
        self.rect(rect, UIColor.white.cgColor);
        if let id = UserDefaults.standard.string(forKey:"studentid"){
            drawBarcode(encoded: "*\(id)*",ratio: 2.5, rect: CGRect(x: (rect.width-209)/2.0, y: 0, width: 209, height: rect.height));
        }
    }
    
    func rect(_ rect: CGRect, _ color: CGColor = UIColor.black.cgColor){
        let ctx = UIGraphicsGetCurrentContext()!
        ctx.addRect(rect)
        ctx.setFillColor(color)
        ctx.fillPath()
    }
    
    func drawBarcode(encoded: String, ratio: CGFloat, rect: CGRect) {
        let shortSpacing = rect.width / ((CGFloat(encoded.count)*(3*ratio + 7)) - 1);
        let longSpacing = ratio*shortSpacing;
        
        var x = rect.minX;
        for char in encoded {
            let arr = barcodes[char]!;
            for bar in arr {
                if(bar == "b"){
                    self.rect(CGRect(x: x,y: rect.minY, width: shortSpacing, height: rect.height));
                    x+=shortSpacing;
                }
                else if(bar == "w"){
                    x+=shortSpacing;
                }
                else if(bar == "B"){
                    self.rect(CGRect(x: x,y: rect.minY, width: longSpacing, height: rect.height));
                    x+=longSpacing;
                }
                else if(bar == "W"){
                    x+=longSpacing;
                }
            }
            x+=shortSpacing;
        }
    }
}

extension String {
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
}
