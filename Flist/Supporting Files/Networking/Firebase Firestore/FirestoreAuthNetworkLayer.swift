//
//  FirestoreAuthNetworkLayer.swift
//  Flist
//
//  Created by Roman Sirokov on 01/02/2019.
//  Copyright © 2019 Flist. All rights reserved.
//

import FirebaseAuth
import FirebaseFirestore
import FirebaseMessaging
import FirebaseStorage

class FirestoreAuthNetworkLayer: FirestoreLayer, AuthNetworkLayer {
        
    
    // FirebaseAuth part
    
    public func getUserEmail() -> String {
        return Auth.auth().currentUser!.email!
    }
    
    public func authorization(email: String, password: String, completionHandler: @escaping LayerAuthResultCallback) {
        
        Auth.auth().signIn(withEmail: email, password: password) {
            (authResult, error) in
            completionHandler(authResult?.user.uid, error)
        }
        
    }
    
    public func logout() throws { try Auth.auth().signOut() }

    
    // FirebaseMessanging
    
    public func getFCMToken() -> String? { return Messaging.messaging().fcmToken }
    
    
    
    // FirebaseFirestore
    
    func registration(username: String, password: String, email: String, completionHandler: @escaping LayerAuthResultCallback) {
        
        Auth.auth().createUser(withEmail: email, password: password) {
            (authResult, error) in
            
            guard let user = authResult?.user else {
                completionHandler(nil, error)
                return
            }
            
            
            var dict: [String: Any]
            
            // Initializations of other standard data (such as verified status, timestamp and username lowercased) happens automatically on server (e.g., Firebase Functions)
            dict = [
                "username": username
            ]
            
            self.db.collection("users").document(user.uid).setData(dict)
            
            // Send email verification letter to the user's email
            user.sendEmailVerification(completion: nil)
            
            // Handle completion
            completionHandler(authResult?.user.uid, error)
        }
        
    }
    
    func addFCMToken(token: String?) {
        
        guard let usr_id = self.getCurrentUID(), let tkn = token else { return }
        
        self.db.collection("users").document(usr_id).updateData([
            "fcm_tokens": FieldValue.arrayUnion([tkn])
        ])
        
    }
    
    
    func getUserProfileInfo(completionHandler: @escaping ((NSDictionary?) -> ())) {
        
        guard let usr_id = self.getCurrentUID() else { return }
        
        self.db.collection("users").document(usr_id).getDocument(){
            
            (doc, err) in
            
            if let doc = doc, doc.exists {
                completionHandler((doc.data()! as NSDictionary))
            }
            
        }
        
    }
    
    public func getUserProfileImage(_ id: String? = nil, completionHandler: @escaping ((Data?, Error?) -> ())) {
        
        let uid = (id == nil) ? getCurrentUID() : id
        
        let url = "profile_imgs/\(String(describing: uid!)).jpg"
        
        // Create a reference to the file you want to upload
        let storageRef = Storage.storage().reference().child(url)
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        storageRef.getData(maxSize: 1 * 1024 * 1024, completion: completionHandler)
        
    }
    

}
