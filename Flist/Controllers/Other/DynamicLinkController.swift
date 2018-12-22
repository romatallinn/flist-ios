//
//  DynamicLinkController.swift
//  Flist
//
//  Created by Роман Широков on 13.04.2018.
//  Copyright © 2018 Flist. All rights reserved.
//

import Foundation
import UIKit

class DynamicLinkController {
    
    public static var isDynamicLink = false
    
    public func FetchIncomingPathComponents(components: [String], appDelegate: AppDelegate) {
        
        componentsLoop: for (key, piece) in components.enumerated() {
            
            if key == 0 && piece == "/" { continue }
            
            switch piece {
                
            case "u": // u - Show User Profile (arg: username)
//                    HandleUserProfileLink(username: components[key+1], appDelegate: appDelegate)
                    break componentsLoop
            
            default: break
                
            }
            
            
        }
        
    }
    
    private func HandleUserProfileLink (username: String, appDelegate: AppDelegate) {
        
        print("GoTo Profile with username: \(username)")

        DynamicLinkController.isDynamicLink = true
        
    }
    
}
