//
//  MyProfileCellUIView.swift
//  Flist
//
//  Created by Роман Широков on 05.11.17.
//  Copyright © 2017 Flist. All rights reserved.
//

import UIKit


@IBDesignable
class MyProfileCellUIView: UIView {

    
    override func layerWillDraw(_ layer: CALayer) {
        
        layer.cornerRadius = 50;
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray.cgColor
    }
    

}
