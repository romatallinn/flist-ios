//
//  LoginViewController.swift
//  Flist
//
//  Created by Роман Широков on 05.11.17.
//  Copyright © 2017 Flist. All rights reserved.
//


import UIKit

class LoginViewController: UIViewController {
    
    // Init defaults for storing user's credentials
    let defaults: UserDefaults? = UserDefaults.standard
    
    // Init authentication model
    var model = AuthModel()
    
    // Auth fields
    @IBOutlet weak var usernameField: LoginFieldAttributes!
    @IBOutlet weak var passwordField: LoginFieldAttributes!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Hide navigation bar if in Auth board
        // Must have when logged out
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    @IBAction func SignInAction(_ sender: Any) {
        
        // Get credentials from fields
        let username = usernameField.text
        let password = passwordField.text
        
        // Ensure the credentials are given
        if((username?.isEmpty)! || (password?.isEmpty)!) {
        
            self.ShowAlert(msg: "All of the input fields are required to be filled!")
            return
        
        }
        
        // Authenticated with given credentials
        model.authorization(email: username!, password: password!) {
            
            (uid, error) in
            
            DispatchQueue.main.async {
                
            
                if let err = error {
                    
                    // If resulted in error -- show it.
                    print(err.localizedDescription)
                    self.ShowAlert(msg: err.localizedDescription)
                    
                } else if let _ = uid {
                   
                    // If authenticated successfully
                    // Check if user went through onboard earlier
                    if (self.defaults?.bool(forKey: "Onboarded") == true) {
                    
                        // If the user did, then go to MenuBase
                        self.present(StoryboardController.getInitialController(withBoardID: "MenuBase"), animated: true, completion: nil)
                    
                    } else {
                        
                        // Otherwise, present him onboard
                        self.present(StoryboardController.getInitialController(withBoardID: "Onboarding"), animated: true, completion: nil)
                        
                    }
                }
                
                
            }
        
        
        }
        
    }
    
    // Unwind segue marker for Registration view and Reset Password view
    @IBAction func unwindToThis(_ segue: UIStoryboardSegue) { }
    

    

}
