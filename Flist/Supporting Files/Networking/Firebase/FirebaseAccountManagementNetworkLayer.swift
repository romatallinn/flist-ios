//
//  FirebaseAccountManagementNetworkLayer.swift
//  Flist
//
//  Created by Роман Широков on 06/11/2018.
//  Copyright © 2018 Flist. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseStorage

class FirebaseAccountManagementNetworkLayer: FirebaseLayer,  AccountManagementNetworkLayer {
    
    func updateEmail(_ to: String, completionHandler: @escaping ((Error?) -> ())) {
        Auth.auth().currentUser?.updateEmail(to: to, completion: completionHandler)
    }
    
    func updatePassword(_ to: String, completionHandler: @escaping ((Error?) -> ())) {
        Auth.auth().currentUser?.updatePassword(to: to, completion: completionHandler)
    }
    
    func updateName(_ to: String) {
        
        guard let uid = self.getCurrentUID() else { return }
        
        let data = ["name" : to]
        self.ref.child("users/\(String(describing: uid))").updateChildValues(data)
        
    }
    
    func updateSurname(_ to: String) {
        
        guard let uid = self.getCurrentUID() else { return }
        
        let data = ["surname" : to]
        self.ref.child("users/\(String(describing: uid))").updateChildValues(data)
        
    }
    
    func updateProfile(_ to: [String : Any]) {
        
        guard let uid = self.getCurrentUID() else { return }
        
        self.ref.child("users/\(uid)").updateChildValues(to)
        
    }
    
    public func uploadProfileImg(fileName: String, imgData: Data, completionHandler: @escaping ((Error?)->())) {
        
        guard let uid = getCurrentUID() else { return }
        
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
            
            // Save timestamp of the image for caching purposes
            self.ref.child("users/\(uid)/img_update").setValue(NSDate.GetTimestamp())
            
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
