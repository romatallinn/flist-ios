//
//  AuthModel.swift
//  Flist
//
//  Created by Роман Широков on 06/11/2018.
//  Copyright © 2018 Flist. All rights reserved.
//

import Foundation
import UIKit

class AuthModel {
    
    let networkLayer = NetworkLayer.auth
    
    public func isAuth() -> Bool { return networkLayer.getCurrentUID() != nil }
    public func getUserEmail() -> String { return networkLayer.getUserEmail() }
    
    public func authorization(email: String, password: String, completionHandler: @escaping AuthNetworkLayer.LayerAuthResultCallback) {
        
        networkLayer.authorization(email: email, password: password) {
            (uid, error) in
            
            self.networkLayer.addFCMToken(token: self.networkLayer.getFCMToken())
            completionHandler(uid, error)
        }
        
    }
    
    public func registration(username: String, password: String, email: String, completionHandler: @escaping AuthNetworkLayer.LayerAuthResultCallback) {

        networkLayer.registration(username: username, password: password, email: email) { (uid, error) in
            completionHandler(uid, error)
        }

    }
    
    public func getUserProfileInfo(completionHandler: @escaping ((ProfileInfoElement?) -> ())) {
        
        networkLayer.getUserProfileInfo { (data) in
            
            if let dt = data {
                completionHandler(ProfileInfoElement(dt))
            } else {
                completionHandler(nil)
            }
            
        }
    }
    
    public func getUserProfileImage(uid: String? = nil, completionHandler: @escaping ((UIImage?) -> ())) {
        
        let uid = (uid == nil) ? networkLayer.getCurrentUID() : uid!
        
        networkLayer.getUserProfileImage(uid) { (data, error) in
            
            if error != nil {
                print("Load Profile Image Error: %@)", error.debugDescription)
            } else if let dt = data {
                let image = UIImage(data: dt)
                completionHandler(image!)
            }
            
            completionHandler(nil)
            
        }
    }
    
    public func logout() {
        do {
            try networkLayer.logout()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    
    
}
