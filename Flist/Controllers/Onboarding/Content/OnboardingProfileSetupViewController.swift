//
//  OnboardingContentTwoViewController.swift
//  Flist
//
//  Created by Роман Широков on 27.03.18.
//  Copyright © 2018 Flist. All rights reserved.
//

import UIKit

class OnboardingProfileSetupViewController: OnboardingContentViewController {

    
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var surnameField: UITextField!
    @IBOutlet weak var descField: UITextView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
                
        model.getProfileInfo() {
            (inf) in
            
            
            if let info = inf {
                let infoElement = ProfileInfoElement(info)
                                
                self.nameField.text = infoElement.name
                self.surnameField.text = infoElement.surname
                self.descField.text = infoElement.desc
                
                if infoElement.name.isEmpty {
                    self.pageViewController?.dataSource = nil
                }
                
            }
            
        }
        
    }
    
    @IBAction func nextBtnAction(_ sender: Any) {
                
        guard let name = nameField.text, !name.isEmpty else {
            self.ShowAlert(msg: "Name field cannot be empty!")
            return
        }

        let surname = surnameField.text
        let desc = descField.text
        
        self.pageViewController?.dataSource = self.pageViewController
        
        var data: [String: Any] = [:]
        
        data["name"] = name
        data["surname"] = surname
        data["description"] = desc
        
        let model = ProfileManageModel()
        model.updateProfile(data)
        
        self.NextPage()
        
    }
    
}
