//
//  MainButtonView.swift
//  Flist
//
//  Created by Роман Широков on 05.11.17.
//  Copyright © 2017 Flist. All rights reserved.
//


import UIKit

@IBDesignable
class MainButtonView: UIButton, MainGradientProtocol {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.backgroundColor = nil
        
        let gradient = self.getHorizontalGradientLayer()
        
        gradient.cornerRadius = self.frame.size.height / 3
        gradient.frame = self.bounds

        self.layer.insertSublayer(gradient, at: 0)
        
        
    }
    
}

