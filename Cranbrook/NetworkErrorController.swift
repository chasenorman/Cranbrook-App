//
//  NetworkErrorController.swift
//  Cranbrook
//
//  Created by Chase Norman on 2/14/18.
//  Copyright © 2018 Chase Norman. All rights reserved.
//

import Foundation
import UIKit

class NetworkErrorController: UIViewController{
    @IBAction func retryButton(_ sender: Any) {
        performSegue(withIdentifier: "retry", sender: nil)
    }
    
}
