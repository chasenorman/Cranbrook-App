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
    
    @IBOutlet weak var barcodeView: UIView!
    static var staticBarcodeView: BarcodeView? = nil;
    
    override func viewDidLoad() {
        passwordContainerView.delegate = self
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        AccountController.staticBarcodeView = (barcodeView as! BarcodeView);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }
    
    //The basic setup of the static cells is created by me.
    //Also, the sign-out Alamofire API request is done by me.
    func performSignOut (url : String, parameters : [String : String]){
        Alamofire.request(url, method: .get, parameters: parameters).responseString 
    }

    @IBAction func signOut(_ sender: UIButton) {
        let params : [String : String] = ["token" : UserDefaults.standard.string(forKey: "token")!]
        performSignOut(url: SIGN_OUT_URL, parameters: params)
        self.tabBarController!.performSegue(withIdentifier: "login", sender: nil)
    }
    
    @IBAction func inputID(_ sender: UIButton) {
        let loginVC: UIViewController = (storyboard?.instantiateViewController(withIdentifier: "BlurPasswordLoginViewController"))!
        loginVC.modalPresentationStyle = .overCurrentContext;
        present(loginVC, animated: true, completion: nil);
    }
    
    static func reloadBarcode(){
        AccountController.staticBarcodeView!.setNeedsDisplay();
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
