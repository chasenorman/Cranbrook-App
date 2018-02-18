//
//  TableViewController.swift
//  Cranbrook
//
//  Created by Aziz Zaynutdinov on 2/16/18.
//  Edited by Chase Norman.
//  Copyright © 2018 Chase Norman. All rights reserved.
//
import UIKit

class AccountController : UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }
    
    @IBAction func signOut(_ sender: UIButton) {
        UserDefaults.standard.removeObject(forKey: "username");
        UserDefaults.standard.removeObject(forKey: "password")
        UserDefaults.standard.removeObject(forKey: "token")
        performSegue(withIdentifier: "signOut", sender: nil)
    }
}
