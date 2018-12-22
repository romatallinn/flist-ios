//
//  TextFieldReturnResignable.swift
//  Flist
//
//  Created by Роман Широков on 09.11.17.
//  Copyright © 2017 Flist. All rights reserved.
//

import UIKit

// Text Field resignable on return key
class TextFieldReturnResignable: UITextField, UITextFieldDelegate {
    
    override init(frame: CGRect) {
        super.init(frame:frame)

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.delegate = self
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
        
    }
    
}
