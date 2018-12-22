//
//  TextViewReturnResignable.swift
//  Flist
//
//  Created by Роман Широков on 26.03.18.
//  Copyright © 2018 Flist. All rights reserved.
//

import UIKit

// Text View resignable on return key
class TextViewReturnResignable: UITextView, UITextViewDelegate {
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame:frame, textContainer:textContainer)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.delegate = self
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
       
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        
        return true
    }

    
}

