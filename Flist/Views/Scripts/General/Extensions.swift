//
//  Extensions.swift
//  Flist
//
//  Created by Роман Широков on 05.12.17.
//  Copyright © 2017 Flist. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func roundView() {
        self.layer.cornerRadius = self.frame.size.width/2
        self.clipsToBounds = true
    }
    
}

extension UIImage {
    
    func crop( rect: CGRect) -> UIImage {
        let imageRef = self.cgImage!.cropping(to: rect)
        let image = UIImage(cgImage: imageRef!, scale: self.scale, orientation: self.imageOrientation)
        return image
    }
    
}

extension NSURL {
    
    static func VerifyUrl (_ urlString: String?) -> Bool {
        //Check for nil
        if let urlStr = urlString {
            // create NSURL instance
            if let url = NSURL(string: urlStr) {
                // check if your application can open the NSURL instance
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
    
}

extension UIButton {
    
    func SetBorder(width: CGFloat = 1.0, color: UIColor? = nil, cornerRadius: CGFloat = 5.0) {
        
        self.layer.borderWidth = width
        self.layer.borderColor = color == nil ? tintColor.cgColor : color!.cgColor
        self.layer.cornerRadius = cornerRadius
        
    }
    
}

extension UIColor {
    
    static var mainColorTheme: UIColor {
        return UIColor(red: 104/255, green: 219/255, blue: 213/255, alpha: 1) // #68DBD5
    }
    
    func lighter(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: abs(percentage) )
    }

    func darker(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }

    func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: min(red + percentage/100, 1.0),
                           green: min(green + percentage/100, 1.0),
                           blue: min(blue + percentage/100, 1.0),
                           alpha: alpha)
        } else {
            return nil
        }
    }
}

extension NSDate {
    
    static func GetTimestamp() -> String {
        
        let date = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        return dateFormatter.string(from: date as Date)
        
    }
    
    static func IntervalSince(_ formattedDate: String) -> Int {

        let cur = NSDate()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let earlier = dateFormatter.date(from: formattedDate)
    
        return Int(cur.timeIntervalSince(earlier!) / 3600)
    }
    
}

extension UIViewController {
    
    func ShowAlert(title: String = "Error", msg: String, actionTitle: String = "OK") {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
  
}

extension String {
    
    static func isValidInput(str: String, reg: String) -> Bool {
        
        let tst = NSPredicate(format: "SELF MATCHES %@", reg)
        return tst.evaluate(with: str)
        
    }
    
}

