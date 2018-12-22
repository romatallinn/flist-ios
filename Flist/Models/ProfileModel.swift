//
//  ProfileModel.swift
//  Flist
//
//  Created by Роман Широков on 07/11/2018.
//  Copyright © 2018 Flist. All rights reserved.
//

import Foundation
import UIKit

class ProfileModel {
    
    let networkLayer = NetworkLayer.profile
    
    public static let ProfileWebURL = "https://flist.me/u/"
    
    public func getFullProfileWith(username: String, completionHandler: @escaping FirebaseProfileNetworkLayer.FullProfileCallback) {
        networkLayer.getFullProfileWith(username: username, completionHandler: completionHandler)
    }
    
    public func getFullProfileWith(userID: String? = nil, completionHandler: @escaping FirebaseProfileNetworkLayer.FullProfileCallback) {
        let uid = (userID == nil) ? networkLayer.getCurrentUID() : userID
        networkLayer.getFullProfileWith(userID: uid!, completionHandler: completionHandler)
    }
    
    public func getProfileInfo(_ userID: String? = nil, completionHandler: @escaping ((NSDictionary?) -> ())) {
        let uid = (userID == nil) ? networkLayer.getCurrentUID() : userID
        networkLayer.getProfileInfo(uid!, completionHandler: completionHandler)
    }
    
    public func getProfileGroups(_ userID: String? = nil, completionHandler: @escaping ((NSDictionary?) -> ())) {
        let uid = (userID == nil) ? networkLayer.getCurrentUID() : userID
        networkLayer.getProfileGroups(uid!, completionHandler: completionHandler)
    }
    
    public func getProfileCards(_ userID: String? = nil, completionHandler: @escaping ((NSDictionary?) -> ())) {
        let uid = (userID == nil) ? networkLayer.getCurrentUID() : userID
        networkLayer.getProfileCards(uid!, completionHandler: completionHandler)
    }
    
    public func loadCustomCardIcon(uid: String? = nil, card_id: String, completionHandler: @escaping ((UIImage) -> ())) {
      
        let uid = (uid == nil) ? networkLayer.getCurrentUID() : uid
        
        networkLayer.loadCustomCardIcon(uid: uid!, card_id: card_id) { (data, error) in
            
            if let error = error {
                print("Error loading custom icon: " + error.localizedDescription)
            } else {
                let image = UIImage(data: data!)
                completionHandler(image!)
            }
            
        }
        
    }
    

}
