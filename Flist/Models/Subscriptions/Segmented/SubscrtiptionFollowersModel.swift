//
//  SubscrtiptionFollowersModel.swift
//  Flist
//
//  Created by Роман Широков on 28.03.18.
//  Copyright © 2018 Flist. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class SubscrtiptionFollowersModel: SubscriptionsModel {

    var followersList = [Any]()
    
    public override func GetSubscriptionData (completionHandler: @escaping ([Any]) -> ()) {
        
        GetFollowersList {
            (list) in
            completionHandler(list)
        }
        
    }
    
    func GetFollowersList(completionHandler: @escaping ([Any]) -> ()) {
        
        followersList = [Any]()
        
        self.ref.child("followers/\(usr_id)").observeSingleEvent(of: .value, with: {
            (snapshot) in
            
            if let followers_list = snapshot.value as? NSDictionary {
                
                for (follower_id, value) in followers_list {
                    
                    let val = value as! [String: Any]
                    
                    self.ref.child("users/\(follower_id)").observeSingleEvent(of: .value, with: {
                        (follower_snapshot) in
                        
                        
                        if var sub = follower_snapshot.value as? [String: Any] {
                            
                            sub["user_id"] = follower_id
                            sub["date"] = val["date"]
                            
                            self.followersList.append(sub)
                            
                            if(self.followersList.count == followers_list.count ) {
                                completionHandler(self.followersList)
                            }
                            
                        }
                        
                        
                    })
                    
                }
            }
        
        })
        
        completionHandler([Any]())
        
    }
    
}
