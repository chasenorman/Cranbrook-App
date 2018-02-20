//
//  LoginController.swift
//  Cranbrook
//
//  Created by Chase Norman on 2/11/18.
//  Edited by Aziz Zaynutdinov.
//  Copyright © 2018 Chase Norman. All rights reserved.
//

import Foundation
import UIKit
import BRYXBanner
import Alamofire
import SwiftyJSON

let LOGIN_URL = "https://cranbrook.myschoolapp.com/api/authentication/login/"

class LoginController : UIViewController{
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    override func viewDidLoad(){
        usernameField.isUserInteractionEnabled = true;
        passwordField.isUserInteractionEnabled = true;
        loading.hidesWhenStopped = true;
    }
    
    func performLogin (url : String, parameters : [String : String]){
        Alamofire.request(url, method: .get, parameters: parameters).responseString {
            response in
            let responseJSON = response.result.value!
            if responseJSON.range(of: "\"TokenId\":0") != nil
            {
                UserDefaults.standard.set(responseJSON [responseJSON.index(responseJSON.startIndex, offsetBy: 10)..<responseJSON.index(responseJSON.endIndex, offsetBy: -31)], forKey: "token")
                self.performSegue(withIdentifier: "enter", sender: self)
            }
            else {
                self.loginFailure()
            }
        }
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        usernameField.isUserInteractionEnabled = false;
        passwordField.isUserInteractionEnabled = false;
        loading.startAnimating();
        let params : [String : String] = ["username" : self.usernameField.text!, "password" : self.passwordField.text!]
        performLogin(url: LOGIN_URL, parameters: params)
    }
    
    func loginFailure(){
        DispatchQueue.main.async{
            self.usernameField.isUserInteractionEnabled = true;
            self.passwordField.isUserInteractionEnabled = true;
            self.loading.stopAnimating();
            let errorBanner = Banner(title: "Error", subtitle: "Incorrect username or password.", image: nil, backgroundColor: UIColor.red, didTapBlock: nil)
            errorBanner.dismissesOnTap = true
            errorBanner.show(duration: 3.0)
        }
    }
}

