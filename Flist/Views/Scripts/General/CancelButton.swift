//
//  CancelButton.swift
//  Flist
//
//  Created by Роман Широков on 08.04.2018.
//  Copyright © 2018 Flist. All rights reserved.
//

import UIKit

@IBDesignable
class CancelButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.size.height / 3
    }

}
