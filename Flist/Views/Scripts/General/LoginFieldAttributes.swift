//
//  LoginFieldAttributes.swift
//  Flist
//
//  Created by Роман Широков on 05.11.17.
//  Copyright © 2017 Flist. All rights reserved.
//


import UIKit

@IBDesignable
class LoginFieldAttributes: TextFieldReturnResignable {

    @IBInspectable var title: String = ""
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        
        SetupBorder()
        SetupTitle()

    }
    
    private func SetupBorder() {
        self.layer.borderColor = UIColor(white: 231 / 255, alpha: 1).cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 6
    }
    
    private func SetupTitle(){
        let title = UILabel(frame: CGRect(x: 10, y: 5, width: 140, height: 20))
        title.text = self.title.uppercased()
        title.textColor = UIColor(red: 132/255, green: 132/255, blue: 132/255, alpha: 1)
        title.font = UIFont(name: "HelveticaNeue-Light", size: 13)
        
        self.addSubview(title)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 10)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
    
    
}
