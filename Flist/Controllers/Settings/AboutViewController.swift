//
//  AboutViewController.swift
//  Together
//
//  Created by Роман Широков on 08.07.17.
//  Copyright © 2017 Roman Sirokov. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (self.navigationController?.isNavigationBarHidden)! {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
        
        if (self.tabBarController?.tabBar.isHidden)! {
            self.tabBarController?.tabBar.isHidden = false
        }
    }

}
