//
//  FirebaseProfileManagementNetworkLayer.swift
//  Flist
//
//  Created by Роман Широков on 06/11/2018.
//  Copyright © 2018 Flist. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

class FirebaseProfileManagementNetworkLayer: FirebaseLayer, ProfileManagementNetworkLayer {
    
    func getCardTemplates(completionHandler: @escaping ((NSDictionary?) -> ())) {
        completionHandler(nil)
    }
    
    func addCard(_ data: [String : Any]) -> String {
        
        guard let uid = self.getCurrentUID() else { return "-1" }
        
        let childRef = self.ref.child("cards/\(uid)").childByAutoId()
        childRef.setValue(data)
        
        return childRef.key!
        
    }
    
    func addGroup(_ data: [String : Any]) {
        
        guard let uid = self.getCurrentUID() else { return }
        
        self.ref.child("groups/\(uid)").childByAutoId().setValue(data)
        
    }
    
    func updateCard(_ data: [String : Any]?, id: String) {
        
        guard let uid = self.getCurrentUID() else { return }

        if let d = data { self.ref.child("cards/\(uid)/\(id)").updateChildValues(d) }
        else {
            
            self.ref.child("cards/\(uid)/\(id)").removeValue()
            
            // Delete custom icon, if any
            Storage.storage().reference().child("custom_card_icons/\(uid)/\(id).jpg").delete(completion: nil)
        }
    }
    
    func updateGroup(_ data: [String : Any]?, group_id: String) {
        
        guard let uid = self.getCurrentUID() else { return }
        
        if let d = data {
            self.ref.child("groups/\(uid)/\(group_id)").updateChildValues(d)
        } else {
            self.ref.child("groups/\(uid)/\(group_id)").removeValue()
        }
        
    }
    
    func updateProfile(_ data: [String : Any]) {

        guard let uid = self.getCurrentUID() else { return }
        
        self.ref.child("users/\(uid)").updateChildValues(data)

    }
    
    
    func uploadCustomCardIcon(fileName: String, imgData: Data, completionHandler: @escaping (() -> ())) {
        
        guard let uid = getCurrentUID() else { return }
        
        let url = "custom_card_icons/\(String(describing: uid))/\(fileName)"
        
        let storageRef = Storage.storage().reference().child(url)
        
        _ = storageRef.putData(imgData, metadata: nil) {
            
            (metadata, error) in
            
            if let error = error {
                print("Upload Profile Image Error: \(error.localizedDescription)")
            }
            
        }
        
        completionHandler()
        
    }
    
}
