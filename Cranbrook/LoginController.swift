//
//  LoginController.swift
//  Cranbrook
//
//  Created by Chase Norman on 2/11/18.
//  Copyright © 2018 Chase Norman. All rights reserved.
//

import Foundation
import UIKit

class LoginController : UIViewController{
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    override func viewDidLoad(){
        usernameField.isUserInteractionEnabled = true;
        passwordField.isUserInteractionEnabled = true;
        loading.hidesWhenStopped = true;
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        usernameField.isUserInteractionEnabled = false;
        passwordField.isUserInteractionEnabled = false;
        loading.startAnimating();
        LoginController.login(username: usernameField.text!, password: passwordField.text!, completionHandler: loginSuccess, errorHandler: loginFailure)
    }
    
    func loginSuccess(){
        DispatchQueue.main.async{
            self.usernameField.isUserInteractionEnabled = true;
            self.passwordField.isUserInteractionEnabled = true;
            self.loading.stopAnimating();
            UserDefaults.standard.set(self.usernameField.text!,forKey: "username");
            UserDefaults.standard.set(self.passwordField.text!, forKey: "password");
            self.performSegue(withIdentifier: "enter", sender: nil);
        }
    }
    
    func loginFailure(){
        DispatchQueue.main.async{
            self.usernameField.isUserInteractionEnabled = true;
            self.passwordField.isUserInteractionEnabled = true;
            self.loading.stopAnimating();
        //some failure message?
        }
    }
    
    static func login(username: String, password: String, completionHandler: @escaping ()->Void, errorHandler: @escaping ()->Void){
        var request = URLRequest(url: URL(string: "https://cranbrook.myschoolapp.com/api/SignIn")!);
        request.httpMethod = "POST";
        request.setValue("application/json", forHTTPHeaderField: "Content-Type");
        let json: [String:Any] = ["From":"","Username":username,"Password":password,"remember":false,"InterfaceSource":"WebApp"];
        let jsonData = try? JSONSerialization.data(withJSONObject: json);
        request.httpBody = jsonData;
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let str = response?.description{
                if let index = str.range(of:"\"t=")?.upperBound{
                    UserDefaults.standard.set(String(str[index..<str.index(index,offsetBy: 36)]), forKey: "token");
                    completionHandler();
                }
                else{
                    errorHandler();
                }
            }
            else{
                errorHandler();
            }
        }
        task.resume();
    }
}
