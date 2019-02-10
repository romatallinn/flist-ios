//
//  FirestoreAccountManagementNetworkLayer.swift
//  Flist
//
//  Created by Roman Sirokov on 02/02/2019.
//  Copyright © 2019 Flist. All rights reserved.
//

import FirebaseAuth
import FirebaseStorage

class FirestoreAccountManagementNetworkLayer: FirestoreLayer, AccountManagementNetworkLayer {
    
    func updateEmail(_ to: String, completionHandler: @escaping ((Error?) -> ())) {
        Auth.auth().currentUser?.updateEmail(to: to, completion: completionHandler)
    }
    
    func updatePassword(_ to: String, completionHandler: @escaping ((Error?) -> ())) {
        Auth.auth().currentUser?.updatePassword(to: to, completion: completionHandler)
    }
    
    func updateName(_ to: String) {
        
        guard let uid = self.getCurrentUID() else { return }
        
        let data = ["name" : to]
        
        self.db.collection("users").document(uid).updateData(data){
            
                (err) in
                
                if let err = err {
                    print("Error updating PROFILE NAME doc: \(err)")
                }
                
        }
        
    }
    
    func updateSurname(_ to: String) {
        
        guard let uid = self.getCurrentUID() else { return }
        
        let data = ["surname" : to]
        
        self.db.collection("users").document(uid).updateData(data){
            
            (err) in
            
            if let err = err {
                print("Error updating PROFILE SURNAME doc: \(err)")
            }
            
        }
        
    }
    
    func updateProfile(_ to: [String : Any]) {
        
        guard let uid = self.getCurrentUID() else { return }
        
        self.db.collection("users").document(uid).updateData(to){
            
            (err) in
            
            if let err = err {
                print("Error updating PROFILE doc: \(err)")
            }
            
        }
        
    }
    
    func uploadProfileImg(fileName: String, imgData: Data, completionHandler: @escaping ((Error?) -> ())) {
        
        guard let uid = self.getCurrentUID() else { return }
        
        let path = "profile_imgs/" + fileName
        
        let storageRef = Storage.storage().reference().child(path)
        
        let upload = storageRef.putData(imgData, metadata: nil) {
            
            (metadata, error) in
            
            if metadata == nil {
                completionHandler(error)
            }
            
        }
        
        upload.observe(.success) {
            
            (snapshot) in
            
            let data = ["img_update" : NSDate.GetTimestamp()]

            // Save timestamp of the image for caching purposes
            self.db.collection("users").document(uid).updateData(data)
            
        }
        
        upload.observe(.failure) {
            
            (snapshot) in
            
            // FAILURE to upload profile image?
        }
        
        completionHandler(nil)
        
    }
    
    func requestPasswordReset(_ withEmail: String, completionHandler: @escaping ((Error?) -> ())) {
        Auth.auth().sendPasswordReset(withEmail: withEmail) { (error) in completionHandler(error) }
    }
    

    
    
}
