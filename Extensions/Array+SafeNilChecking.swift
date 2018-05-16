//
//  Array+SafeNilChecking.swift
//  Cranbrook
//
//  Created by Aziz Zaynutdinov on 5/16/18.
//  Copyright © 2018 Chase Norman. All rights reserved.
//

import Foundation

extension Collection {
    
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
