//
//  SubscrtiptionFollowingModel.swift
//  Flist
//
//  Created by Роман Широков on 28.03.18.
//  Copyright © 2018 Flist. All rights reserved.
//

import Foundation
import FirebaseAnalytics
import FirebaseDatabase


class SubscrtiptionFollowingModel: SubscriptionsModel {
    
    var followingList = [Any]()

    public override func GetSubscriptionData (completionHandler: @escaping ([Any]) -> ()) {
        
        followingList = [Any]()
        
        self.ref.child("following/\(usr_id)").observeSingleEvent(of: .value, with: {
            (snapshot) in
            
            if let following_list = snapshot.value as? NSDictionary {
                
                for (following_id, value) in following_list {
                    
                    let val = value as! [String: Any]
                    
                    self.ref.child("users/\(following_id)").observeSingleEvent(of: .value, with: {
                        
                        (following_snapshot) in
                        
                        if var sub = following_snapshot.value as? [String: Any] {
                            
                            
                            sub["user_id"] = following_id
                            sub["date"] = val["date"]
                            
                            self.followingList.append(sub)
                            
                            if(self.followingList.count == following_list.count ) {
                                completionHandler(self.followingList)
                            }
                            
                            
                        }
                        
                        
                    })
                    
                }

            }
            
            
        })
        
         completionHandler([Any]())
        
    }
    
    public func FollowUserWithUsername(_ following_username: String, completionHandler: @escaping (String?) -> ()) {
        
        self.ref.child("users").queryOrdered(byChild: "username_lowercased").queryEqual(toValue: following_username.lowercased()).observeSingleEvent(of: .value, with: {
            
            (snapshot) in
            
            if let following_id = (snapshot.value as? NSDictionary)?.allKeys[0] as? String {
                
                if following_id == self.usr_id {
                    
                    completionHandler("This is your own account.")
                    return
                    
                } else {
                    
                    self.ref.child("following/\(self.usr_id)/\(following_id)").observeSingleEvent(of: .value, with: {
                        (following_snap) in
                        
                        
                        if !(following_snap.value is NSNull) {
                            print("DATA: " + following_snap.value.debugDescription)
                            completionHandler("You already follow this user.")
                            return
                        }
                        
                    
                        let dateStamp = NSDate.GetTimestamp()
                        
                        let following_data = ["date": dateStamp]
                        self.ref.child("following/\(self.usr_id)/\(following_id)").setValue(following_data)
                        // NB! The DB entry is mirrored to "followers".
                        
                        // Firebase Analytics -- Follow User event
                        Analytics.logEvent("user_followed", parameters: [
                            "username_followed": following_username
                            ])
                        
                        completionHandler(nil)
                    })
                }
                
            } else {
                
                completionHandler("Such user was not found!")
                return
                
            }
            
        })
        
    }
    
    public func UnfollowUserWithId(_ following_id: String, completionHandler: @escaping (Bool) -> ()) {
        
        self.ref.child("following/\(usr_id)/\(following_id)").observeSingleEvent(of: .value, with: {
            
            (snapshot) in
            
            if snapshot.value != nil {
                
                snapshot.ref.removeValue()
                completionHandler(true)
            }
            
            completionHandler(false)
            
        })
    
    }

}
