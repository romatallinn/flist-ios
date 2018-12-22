//
//  NavBarGeneral.swift
//  MyApp
//
//  Created by Роман Широков on 12.04.17.
//  Copyright © 2017 Roman Sirokov. All rights reserved.
//

import UIKit

@IBDesignable
class NavBarGeneral: UINavigationController, MainGradientProtocol {

    var gradient: CAGradientLayer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
        self.navigationBar.backgroundColor = UIColor.clear
        
        self.navigationBar.tintColor = UIColor.white
        
        SetupGradientLayer()
        
    }
        
    override func setNavigationBarHidden(_ hidden: Bool, animated: Bool) {
        super.setNavigationBarHidden(hidden, animated: animated)

        
        if hidden && gradient != nil {
            gradient.removeFromSuperlayer()
            gradient = nil
        } else if hidden == false {
            SetupGradientLayer()
        }
    }
    
    func SetupGradientLayer(){
        
        if gradient == nil {
            gradient = self.getHorizontalGradientLayer()
            gradient.frame = CGRect(x: 0, y:0, width: UIApplication.shared.statusBarFrame.width, height: UIApplication.shared.statusBarFrame.height + (self.navigationBar.frame.height))
            
            
            self.view.layer.insertSublayer(gradient, at: 1)
        } else if(gradient.isHidden) {
            
            gradient.isHidden = false
            
        }
    
    }


}
