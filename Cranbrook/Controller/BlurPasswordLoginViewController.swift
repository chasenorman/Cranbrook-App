//
//  BlurPasswordLoginViewController.swift
//
//  Created by rain on 4/22/16.
//  Copyright © 2016 Recruit Lifestyle Co., Ltd. All rights reserved.
//

import UIKit
import SmileLock

class BlurPasswordLoginViewController: UIViewController {
    
    @IBOutlet weak var passwordStackView: UIStackView!
    
    //MARK: Property
    var passwordUIValidation: MyPasswordUIValidation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //create PasswordUIValidation subclass
        
        passwordUIValidation = MyPasswordUIValidation(in: passwordStackView)
        
        passwordUIValidation.success = { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
            AccountController.reloadBarcode();
        }
        
        passwordUIValidation.failure = {
            print("*️⃣ failure!")
        }
        passwordUIValidation.view.rearrangeForVisualEffectView(in: self)
        
        passwordUIValidation.view.deleteButtonLocalizedTitle = "Delete"
    }
}

