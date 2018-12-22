//
//  DescriptionTextView.swift
//  Flist
//
//  Created by Роман Широков on 25.03.18.
//  Copyright © 2018 Flist. All rights reserved.
//

import UIKit

// Counter of chars for the description text view.
// Shows how many chars are available.

// The counter is hidden if there are more than 25 chars are available.

// The color of the counter is green-ish for last 25 to 10 chars.
// The color is yellow for last 10 chars.
// The color is red if the limit is reached.

class DescriptionTextView: TextViewReturnResignable {
    
 @IBOutlet weak var charCount: UILabel!

    
    let MaxChars = 126
    
    // Returns true if max limit of chars isn't reached
    // Returns false if the limit (MaxChars) is reached.
    var isAccaptable: Bool {
        get { return self.text.count <= MaxChars }
    }
    
    // Initialize
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.delegate = self
        textViewDidChange(self)
    }
    
    func textViewDidChange(_ textView: UITextView) {
                
        let count = textView.text.count
        var clr: UIColor
        
        // Hide counter if more than 25 chars are available,
        // And show if less than 25 chars are available.
        if count > MaxChars - 25 { charCount.isHidden = false }
        else { charCount.isHidden = true }
        
        // Color if max is reached
        if (count >= MaxChars) {

            clr = UIColor(red: 1, green: 24/225, blue: 0, alpha: 1.0)

        } else if (MaxChars > count && count > MaxChars - 10) // Color for last 10 chars
        {
            
            clr = UIColor(red: 200/225, green: 190/225, blue: 0, alpha: 1.0)
            
        } else // Color for last 25 - 10 chars.
        {

            clr = UIColor(red: 0, green: 156/225, blue: 0, alpha: 1.0)

        }
        
        // Apply color
        charCount.textColor = clr
        
        // Display count (how many chars are available?)
        charCount.text = (MaxChars - count).description


    }
    
    
}
