//
//  ResetPasswordViewController.swift
//  Flist
//
//  Created by Роман Широков on 05.11.17.
//  Copyright © 2017 Flist. All rights reserved.
//


import UIKit

class ResetPasswordViewController: UIViewController {

 
    // Fields
    @IBOutlet weak var emailField: LoginFieldAttributes!
 
    let model = AccountManagementModel()
    
    @IBAction func ResetPassword(_ sender: Any) {
        
        // Send passowrd reset to given email
        model.requestPasswordReset(withEmail: emailField.text!) {
            (error) in
            
            if let err = error {
            
                self.ShowAlert(msg: err.localizedDescription)
                
            } else {
            
                // If sent, segure to Login
                self.performSegue(withIdentifier: "ResetToLogin", sender: nil)

            }
            
        }
        
    }


}
