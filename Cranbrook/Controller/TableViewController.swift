//
//  TableViewController.swift
//  Cranbrook
//
//  Created by Aziz Zaynutdinov on 2/16/18.
//  Copyright © 2018 Chase Norman. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

        override func viewDidLoad() {
            super.viewDidLoad()
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated
}
    
    @IBAction func signOutButton(_ sender: Any) {
        UserDefaults.standard.set(nil, forKey: "username")
        UserDefaults.standard.set(nil, forKey: "password")
        performSegue(withIdentifier: "signOut", sender: self)
        
    }
    
    
    }
