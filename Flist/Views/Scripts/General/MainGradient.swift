//
//  MainGradient.swift
//  Flist
//
//  Created by Роман Широков on 05.11.17.
//  Copyright © 2017 Flist. All rights reserved.
//

import UIKit

protocol MainGradientProtocol { }

extension MainGradientProtocol {
    
    
    func generalSetup() -> CAGradientLayer {
        
        let gradient = CAGradientLayer()
        let colorTop = UIColor(red: 112.0/255.0, green: 219.0/255.0, blue: 155.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 86.0/255.0, green: 197.0/255.0, blue: 238.0/255.0, alpha: 1.0).cgColor
        
        gradient.colors = [colorTop, colorBottom]
        
        return gradient
    }
    
    func getHorizontalGradientLayer() -> CAGradientLayer {
        
        let gradient = generalSetup()
        
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        return gradient
        
    }
    
    func getLightGradientLayer() -> CAGradientLayer {
        
        let gradient = getHorizontalGradientLayer()
        
        let colorTop = UIColor(red: 112.0/255.0, green: 219.0/255.0, blue: 155.0/255.0, alpha: 1.0).lighter(by: 45)!.cgColor
        let colorBottom = UIColor(red: 86.0/255.0, green: 197.0/255.0, blue: 238.0/255.0, alpha: 1.0).lighter(by: 45)!.cgColor

        gradient.colors = [colorTop, colorBottom]
        
        return gradient
        
    }
    
}
