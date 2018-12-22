//
//  OnboardingContentViewController.swift
//  Flist
//
//  Created by Роман Широков on 27.03.18.
//  Copyright © 2018 Flist. All rights reserved.
//

import UIKit

class OnboardingContentViewController: UIViewController {

    
    var pageViewController: OnboardingViewController?
    
    let model = ProfileModel()
    
    public func SetPageViewController(pageViewController: OnboardingViewController) {
        self.pageViewController = pageViewController
    }
    
    func NextPage() {
        if let pgContr = pageViewController {
            pgContr.NextPage()
        }
    }
    
    func SkipToLast() {
        if let pgContr = pageViewController {
            pgContr.SkipToLast()
        }
    }

}
