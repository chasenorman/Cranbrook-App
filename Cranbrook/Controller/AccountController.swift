//
//  TableViewController.swift
//  Cranbrook
//
//  Created by Aziz Zaynutdinov on 2/16/18.
//  Edited by Chase Norman.
//  Copyright © 2018 Chase Norman. All rights reserved.
//
import UIKit
import Foundation
import Alamofire
import SwiftyJSON
import SmileLock

let SIGN_OUT_URL = "https://cranbrook.myschoolapp.com/api/authentication/logout/?t="

class AccountController : UITableViewController {
    let passwordContainerView = PasswordContainerView.create(withDigit: 7)
    
    override func viewDidLoad() {
        passwordContainerView.delegate = self
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }
    
    func performSignOut (url : String, parameters : [String : String]){
        Alamofire.request(url, method: .get, parameters: parameters).responseString 
    }
    
    @IBAction func signOut(_ sender: UIButton) {
        let params : [String : String] = ["token" : UserDefaults.standard.string(forKey: "token")!]
        performSignOut(url: SIGN_OUT_URL, parameters: params)
        performSegue(withIdentifier: "signOut", sender: nil)
    }
    
    @IBAction func inputID(_ sender: UIButton) {
        
    }
}

extension AccountController: PasswordInputCompleteProtocol {
    func touchAuthenticationComplete(_ passwordContainerView: PasswordContainerView, success: Bool, error: Error?) {
        
    }
    
    func passwordInputComplete(_ passwordContainerView: PasswordContainerView, input: String) {
        print("input completed -> \(input)")
        //handle validation wrong || success
    }
}
