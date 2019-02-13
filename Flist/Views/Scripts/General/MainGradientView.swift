//
//  MainButtonView.swift
//  Flist
//
//  Created by Роман Широков on 05.11.17.
//  Copyright © 2017 Flist. All rights reserved.
//


import UIKit

@IBDesignable
class MainGradientView: UIButton, MainGradientProtocol {

    @IBInspectable var isRadius: Bool = false
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.backgroundColor = nil
        
        let gradient = self.getHorizontalGradientLayer()
        gradient.frame = self.bounds
        
        gradient.cornerRadius = (isRadius) ? self.frame.size.height / 3 : 0

        self.layer.insertSublayer(gradient, at: 0)
        
        
    }
    
}

