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
    
    static func login(completionHandler: @escaping ()->Void, loginErrorHandler: @escaping ()->Void, networkErrorHandler: ()->Void){
        if !Reachability.isConnectedToNetwork(){
            networkErrorHandler()
            return;
        }
        Alamofire.request(LOGIN_URL, method: .post, parameters:
            ["username" : UserDefaults.standard.string(forKey: "username")!, "password" : UserDefaults.standard.string(forKey: "password")!, "InterfaceSource":"WebApp", "remember":false, "From":""] ).responseString {
            response in
            let responseJSON = response.result.value!
                print(responseJSON);
            if responseJSON.range(of: "\"TokenId\":0") != nil
            {
                UserDefaults.standard.set(responseJSON [responseJSON.index(responseJSON.startIndex, offsetBy: 10)..<responseJSON.index(responseJSON.endIndex, offsetBy: -31)], forKey: "token")
                completionHandler();
            }
            else {
                loginErrorHandler();
            }
        }
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        usernameField.isUserInteractionEnabled = false;
        passwordField.isUserInteractionEnabled = false;
        loading.startAnimating();
        UserDefaults.standard.set(self.usernameField.text!, forKey: "username");
        UserDefaults.standard.set(self.passwordField.text!, forKey: "password");
        LoginController.login(completionHandler: loginSuccess, loginErrorHandler: loginFailure, networkErrorHandler: networkError);
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
    
    func networkError(){
        DispatchQueue.main.async{
            self.usernameField.isUserInteractionEnabled = true;
            self.passwordField.isUserInteractionEnabled = true;
            self.loading.stopAnimating();
            let errorBanner = Banner(title: "Error", subtitle: "No connection.", image: nil, backgroundColor: UIColor.red, didTapBlock: nil)
            errorBanner.dismissesOnTap = true
            errorBanner.show(duration: 3.0)
        }
    }
    
    func loginSuccess(){
        self.performSegue(withIdentifier: "enter", sender: self)
    }
}

