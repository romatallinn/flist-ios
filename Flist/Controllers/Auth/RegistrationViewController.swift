//
//  RegistrationViewController.swift
//  Flist
//
//  Created by Роман Широков on 05.11.17.
//  Copyright © 2017 Flist. All rights reserved.
//


import UIKit

class RegistrationViewController: UIViewController {

    // Credential fields
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var rePassField: UITextField!
    
    // Authentication model
    let model = AuthModel()
    
    
    @IBAction func SignUpAction(_ sender: Any) {
    
        
        // Obtain credentials from fields
        let username = usernameField.text
        let email = emailField.text
        let pass = passField.text
        let rePass = rePassField.text
        
        // Ensure that credentials are present
        if((username?.isEmpty)! || (email?.isEmpty)! || (pass?.isEmpty)! || (rePass?.isEmpty)!) {
            self.ShowAlert(msg: "All of input fields are required to be filled!")
            return
        }
        
        // Ensure the username has valid format
        if !String.isValidInput(str: username!, reg: "\\A\\w{5,18}\\z") {
            self.ShowAlert(msg: "Username follows wrong format! It must contain 5 to 18 alphanumerical characters without special symbols!")
            return
        }
        
        // Ensure the password is repeated correctly
        if(rePass != pass) {
            self.ShowAlert(msg: "Password and re-password do not match!")
            return
        }
                
        // Undergo the registration procedure with given credentials
        model.registration(username: username!, password: pass!, email: email!) {
        
            (user, error) in
            
            DispatchQueue.main.async {
            
                if let err = error {
            
                    print("Error RegView: " + err.localizedDescription)
                    self.ShowAlert(msg: err.localizedDescription)

                    return
            
                } else if (user != nil) {
            
                    // If registered successfuly, perform segue to Login
                    self.performSegue(withIdentifier: "RegToLogin", sender: nil)
                    
                }
                
            }
            
        
        
        }
        
    }

}
