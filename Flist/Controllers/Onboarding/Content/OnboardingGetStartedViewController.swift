//
//  OnboardingGetStartedViewController.swift
//  Flist
//
//  Created by Роман Широков on 12/11/2018.
//  Copyright © 2018 Flist. All rights reserved.
//

import UIKit
import FirebaseAnalytics

class OnboardingGetStartedViewController: OnboardingContentViewController {
    
    let defaults: UserDefaults? = UserDefaults.standard

    @IBOutlet weak var linkOutlet: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        model.getProfileInfo() {
            (inf) in
            
            if let info = inf {
                let infoElement = ProfileInfoElement(info)
                self.linkOutlet.text = ProfileModel.ProfileWebURL + infoElement.username
            }
            
        }
        
    }
    
    @IBAction func copyProfileLinkAction(_ sender: Any) {
        
        
        guard let URLStr = linkOutlet.text else { return }

        
        // set up activity view controller
        let stringToShare = [ URLStr ]
        let activityViewController = UIActivityViewController(activityItems: stringToShare, applicationActivities: nil)
        
        activityViewController.completionWithItemsHandler = {
            (activity, success, items, error) in
            
            if success {
                
                // Firebase Analytics -- Onboard Share feature used event
                Analytics.logEvent("onboard_profile_share", parameters: nil)
                
            }
            
        }
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.addToReadingList, UIActivity.ActivityType.airDrop, UIActivity.ActivityType.assignToContact, UIActivity.ActivityType.openInIBooks, UIActivity.ActivityType.postToVimeo, UIActivity.ActivityType.saveToCameraRoll, UIActivity.ActivityType.print ]
        
        // present the view controller
        self.pageViewController!.present(activityViewController, animated: true, completion: nil)
        
    }
    @IBAction func getStartedAction(_ sender: Any) {
        
        UIApplication.shared.statusBarStyle = .lightContent
        defaults?.set(true, forKey: "Onboarded")
        
        self.present(StoryboardController.getInitialController(withBoardID: "MenuBase"), animated: true, completion: nil)
        
    }
    
}
