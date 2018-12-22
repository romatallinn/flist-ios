//
//  FirebaseProfileNetworkLayer.swift
//  Flist
//
//  Created by Роман Широков on 06/11/2018.
//  Copyright © 2018 Flist. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class FirebaseProfileNetworkLayer: FirebaseLayer, ProfileNetworkLayer {
    
    
    
    func getFullProfileWith(userID: String, completionHandler: @escaping FirebaseProfileNetworkLayer.FullProfileCallback) {
        
        self.getProfileInfo(userID) {
            (inf) in
            
            self.getProfileGroups(userID){
                (grps) in
                
                self.getProfileCards(userID) {
                    (crds) in
                    
                    completionHandler(userID, inf, grps, crds)
                    
                }
                
            }
            
        }
    }
    
    func getFullProfileWith(username: String, completionHandler: @escaping FirebaseProfileNetworkLayer.FullProfileCallback) {
        
        self.ref.child("users").queryOrdered(byChild: "username_lowercased").queryEqual(toValue: username.lowercased()).observeSingleEvent(of: .value, with: {
            (snapshot) in
            
            if let uid = (snapshot.value as? NSDictionary)?.allKeys[0] as? String {
                
                self.getFullProfileWith(userID: uid) { (uid, info, groups, cards) in
                    completionHandler(uid, info, groups, cards)
                }
                
                
            }
        })
        
    }
    
    func getProfileInfo(_ userID: String, completionHandler: @escaping ((NSDictionary?) -> ())) {
        
        self.ref.child("users/\(userID)").observeSingleEvent(of: .value, with: {
            (usr_snap) in
            
            let info = usr_snap.value as? NSDictionary
            completionHandler(info)
            
        })
        
    }
    
    func getProfileGroups(_ userID: String, completionHandler: @escaping ((NSDictionary?) -> ())) {
        
        self.ref.child("groups/\(userID)").observeSingleEvent(of: .value, with: {
            (usr_snap) in
            
            let groups = usr_snap.value as? NSDictionary
            completionHandler(groups)
            
        })
        
    }
    
    func getProfileCards(_ userID: String, completionHandler: @escaping ((NSDictionary?) -> ())) {
        
        self.ref.child("cards/\(userID)").observeSingleEvent(of: .value, with: {
            (usr_snap) in
            
            let cards = usr_snap.value as? NSDictionary
            completionHandler(cards)
            
        })
        
    }
    
    func loadCustomCardIcon(uid: String, card_id: String, completionHandler: @escaping ((Data?, Error?) -> ())) {
      
        let url = "custom_card_icons/\(String(describing: uid))/\(card_id).jpg"
        let storageRef = Storage.storage().reference().child(url)
        
        storageRef.getData(maxSize: 1 * 1024 * 1024, completion: completionHandler)
        
    }
    
    func loadCardTypes (completionHandler: @escaping ((NSDictionary?) -> ())) {
        
        self.ref.child("card-types").observeSingleEvent(of: .value, with: {
            (snap) in
            
            let types = snap.value as? NSDictionary
            completionHandler(types)
            
        })
        
    }
    
    func loadIconsForDefaultTypes(type: String, completionHandler: @escaping ((Data?, Error?) -> ())) {
        
        let url = "default-card-icons/\(type).png"
        let storageRef = Storage.storage().reference().child(url)
        
        storageRef.getData(maxSize: 1 * 1024 * 1024, completion: completionHandler)
        
    }

    
}
