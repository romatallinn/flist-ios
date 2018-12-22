//
//  OnboardingContentThreeViewController.swift
//  Flist
//
//  Created by Роман Широков on 27.03.18.
//  Copyright © 2018 Flist. All rights reserved.
//

import UIKit
import UserNotifications

@IBDesignable
class OnboardingPermissionsViewController: OnboardingContentViewController, UNUserNotificationCenterDelegate {
    
    
    @IBOutlet weak var accessDeniedView: UIView!
    
    @IBOutlet weak var retryBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        retryBtn.SetBorder(width: 1, color: retryBtn.tintColor, cornerRadius: 10)
        
        accessDeniedView.isHidden = true
        requestPermission()
        
    }
    
    @IBAction func goToSettingsAction(_ sender: Any) {
    
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (_) in })
        }
    
    }
    
    private func requestPermission() {
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            
            UNUserNotificationCenter.current().requestAuthorization( options: authOptions, completionHandler: {
                (success, error) in
                
                DispatchQueue.main.async {

                    if error == nil {
                        
                        if success == true {
                            
                            self.accessDeniedView.isHidden = true
                            self.NextPage()
                            
                        } else {
                            
                            self.accessDeniedView.isHidden = false
                        }
                        
                    }
                    
                }
                    
            })
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        
    }
    
    
    @IBAction func nextButtonAction(_ sender: Any) {
        
        self.NextPage()

    }
}
