//
//  LoginVC.swift
//  DevChat
//
//  Created by Mark Price on 7/13/16.
//  Copyright © 2016 Devslopes. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var emailField: RoundTextField!
    @IBOutlet weak var passwordField: RoundTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func loginPressed(_ sender: AnyObject) {
        
        if let email = emailField.text, let passwd = passwordField.text, (email.characters.count > 0 && passwd.characters.count > 0) {
            
            // Call the login service
            
            AuthService.instance.login(email: email, password: passwd)
            
            
        } else {
            
            GeneralHelper.sharedHelper.showAlertOnViewController(viewController: self, withTitle: "Username and Password Required", message: "You must enter both a username and a password", buttonTitle: "OK")
            
        }
        
    }
    
}
