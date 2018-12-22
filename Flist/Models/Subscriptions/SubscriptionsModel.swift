//
//  ContactsModel.swift
//  Flist
//
//  Created by Роман Широков on 05.11.17.
//  Copyright © 2017 Flist. All rights reserved.
//


import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseAnalytics

class SubscriptionsModel{
    
    var ref: DatabaseReference!
    
    let usr_id: String
    
    init() {
        ref = Database.database().reference()
        usr_id = (Auth.auth().currentUser?.uid)!
    }
    
    public func GetSubscriptionData (completionHandler: @escaping ([Any]) -> ()) {
                
        fatalError("func GetSubscriptionData in SubscriptionModel superclass must be overriden")
        
    }
    
    public func GetIdForUsername (username: String, completionHandler: @escaping (String?) -> ()) {
        
        self.ref.child("users").queryOrdered(byChild: "username_lowercased").queryEqual(toValue: username.lowercased()).observeSingleEvent(of: .value, with: {
            (snapshot) in
            
            if !snapshot.exists() {
                completionHandler(nil)
            }
            
            for child in snapshot.children {
                
                // Firebase Analytics -- Search (user) event
                Analytics.logEvent(AnalyticsEventSearch, parameters: [
                    AnalyticsParameterSearchTerm: username
                    ])

                
                let key = (child as! DataSnapshot).key
                completionHandler(key)
            }
            
        })
    }
    
}

struct SubscriptionUserListElement {
    
    var id: String
    var fullName: String
    var username: String
    var date: String
    var avatar: UIImage
    var verified: Bool
    
    init(_ data: [String: Any]) {
        self.id = data["user_id"] as! String
        self.fullName = (data["name"] as! String) + " " + (data["surname"] as! String)
        self.username = data["username"] as! String
        self.date = data["date"] as! String
        self.verified = data["verified"] as! Bool
        self.avatar = #imageLiteral(resourceName: "avatar")
    }
    
}

