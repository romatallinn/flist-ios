//
//  FirestoreProfileManagementNetworkLayer.swift
//  Flist
//
//  Created by Roman Sirokov on 01/02/2019.
//  Copyright © 2019 Flist. All rights reserved.
//

import FirebaseFirestore
import FirebaseStorage

class FirestoreProfileManagementNetworkLayer: FirestoreLayer, ProfileManagementNetworkLayer {
    
    
    
    func getCardTemplates(completionHandler: @escaping ((NSDictionary?) -> ())) {
        completionHandler(nil)
    }
    
    func addCard(_ data: [String : Any], group_id: String = "0") -> String {
        
        guard let uid = self.getCurrentUID() else { return "-1" }

        let cardDoc = self.db.collection("users/\(uid)/groups/\(group_id)/cards").addDocument(data: data) {
            
            (error) in
            
            if let err = error {
                print("Error adding CARD: \(err)")
            }
            
        }
        
        return cardDoc.documentID
        
    }
    
    func addGroup(_ data: [String : Any]) -> String {
        
        guard let uid = self.getCurrentUID() else { return "-1" }
        
        let groupDoc = self.db.collection("users\(uid)/groups").addDocument(data: data) {
            
            (error) in
            
            if let err = error {
                print("Error adding GROUP: \(err)")
            }
            
        }
        
        return groupDoc.documentID
        
    }
    
    func updateCard(_ data: [String : Any]?, id: String, group_id: String = "0") {
        
        guard let uid = self.getCurrentUID() else { return }
        
        if let dt = data {
        
            self.db.collection("users/\(uid)/groups/\(group_id)/cards").document(id).updateData(
                dt
            ) {
                (err) in
                
                if let err = err {
                    print("Error updating CARD doc: \(err)")
                }
            }
        
        } else {
        
            self.db.collection("users/\(uid)/groups/\(group_id)/cards").document(id).delete(){
                (err) in
                
                if let err = err {
                    print("Error deleting CARD doc: \(err)")
                }
            }
            
        }
        
    }
    
    func updateGroup(_ data: [String : Any]?, group_id: String) {
        
        guard let uid = self.getCurrentUID()else { return }
        
        if let dt = data {
            self.db.collection("users/\(uid)/groups").document(group_id).updateData(
                dt
            ) {
                (err) in
                
                if let err = err {
                    print("Error updating GROUP doc: \(err)")
                }
            }
            
        } else {
            
            self.db.collection("users/\(uid)/groups").document(group_id).delete(){
                (err) in
                
                if let err = err {
                    print("Error deleting GROUP doc: \(err)")
                }
            }
            
        }
        
        
    }
    
    func updateProfile(_ data: [String : Any]) {
        
        guard let uid = self.getCurrentUID() { return }
        
        self.db.collection("users").document(uid).updateData(
            data
        ) {
            (err) in
            
            if let err = err {
                print("Error adding GROUP doc: \(err)")
            }
        }
        
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
