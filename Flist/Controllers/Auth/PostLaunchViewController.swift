//
//  PostLaunchController.swift
//  Flist
//
//  Created by Роман Широков on 23.11.17.
//  Copyright © 2017 Flist. All rights reserved.
//

import UIKit

class PostLaunchViewController: UIViewController {

    // Init defaults for obtaining user's credentials if any stored
    let defaults: UserDefaults? = UserDefaults.standard
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Init authentication model
        let model = AuthModel()
        
        ServiceModel.loadServices() {
        
            if (!model.isAuth()) {
                
                // If user isn't authorized --- go to Auth
                 self.present(StoryboardController.getInitialController(withBoardID: "Auth"), animated: false, completion: nil)
                
            } else if (self.defaults?.bool(forKey: "Onboarded") == true) {

                // If user is authorized and onboarded --- go to Menu Base
                self.present(StoryboardController.getInitialController(withBoardID: "MenuBase"), animated: true, completion: nil)
                
            } else {
                
                // If user is authorized, but not yet onboarded --- go to Onboarding
                self.present(StoryboardController.getInitialController(withBoardID: "Onboarding"), animated: true, completion: nil)
                
            }
        }
        
    }
    
}
