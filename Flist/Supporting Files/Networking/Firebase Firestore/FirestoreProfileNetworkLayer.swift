//
//  FirestoreProfileNetworkLayer.swift
//  Flist
//
//  Created by Roman Sirokov on 02/02/2019.
//  Copyright © 2019 Flist. All rights reserved.
//

import FirebaseFirestore
import FirebaseStorage

class FirestoreProfileNetworkLayer: FirestoreLayer, ProfileNetworkLayer {
    
    
    func getFullProfileWith(uid: String, completionHandler: @escaping FirestoreProfileNetworkLayer.FullProfileCallback) {
        
        self.getProfileInfo(uid) {
            (info) in
            
            self.getProfileGroups(uid, completionHandler: {
                (groups) in
                
                self.getProfileCards(uid, completionHandler: {
                    (cards) in
                    
                    completionHandler(uid, info, groups, cards)
                    
                })
                
            })
            
        }
        
    }
    
    func getFullProfileWith(username: String, completionHandler: @escaping FirestoreProfileNetworkLayer.FullProfileCallback) {
        
//        self.db.collection("users").whereField("username_lowecased", isEqualTo: username.lowercased()).limit(to: 1)
        
    }
    
    func getProfileInfo(_ uid: String, completionHandler: @escaping ((NSDictionary?) -> ())) {
        
        self.db.collection("users").document(uid).getDocument() {
            
            (document, error) in
            
            if let err = error {
                print("Error getting USERS doc: \(err)")
            }
            
            if let document = document, document.exists {
                
                completionHandler(document.data()! as NSDictionary)
                
            }
            
        }
        
    }
    
    func getProfileGroups(_ uid: String, completionHandler: @escaping ((NSDictionary?) -> ())) {
        
        self.db.collection("users/\(uid)/groups").getDocuments() {
            
            (docs, error) in
            
            if let err = error {
                print("Error getting GROUPS docs: \(err)")
            }
            
            let res = NSDictionary()
            
            if let docs = docs {
                
                
                for doc in docs.documents {
                    res.setValue(doc.data(), forKey: doc.data().keys.first!)
                }
                
                completionHandler(res)
                
            }
            
        }
        
    }
    
    func getProfileCards(_ uid: String, group_id: String = "0", completionHandler: @escaping ((NSDictionary?) -> ())) {
        
        self.db.collection("users/\(uid)/groups/\(group_id)/cards").getDocuments() {
            
            (docs, error) in
            
            if let err = error {
                print("Error getting CARDS docs: \(err)")
            }
            
            let res = NSDictionary()
            
            if let docs = docs {
                
                
                for doc in docs.documents {
                    res.setValue(doc.data(), forKey: doc.data().keys.first!)
                }
                
                completionHandler(res)
                
            }
            
        }
        
    }
    
    
    
    
    func getProfileCards(uid: String, completionHandler: @escaping (([NSDictionary]?) -> ())) {
        
        self.db.collection("users/\(uid)/cards").getDocuments() {
            
            (docs, error) in
            
            if let err = error {
                print("Error getting USERS doc: \(err)")
            }
            
            if let docs = docs {
                
                var cardDocs = [NSDictionary]()
                
                for card in docs.documents {
                    cardDocs.append(card.data() as NSDictionary)
                }

                completionHandler(cardDocs)
                
            }
            
        }
        
    }
    
    func loadCustomCardIcon(uid: String, card_id: String, completionHandler: @escaping ((Data?, Error?) -> ())) {
        
        let url = "custom_card_icons/\(String(describing: uid))/\(card_id).jpg"
        let storageRef = Storage.storage().reference().child(url)
        
        storageRef.getData(maxSize: 1 * 1024 * 1024, completion: completionHandler)
        
    }
    
    func loadCardTypes (completionHandler: @escaping ((NSDictionary?) -> ())) {
        
//        self.ref.child("card-types").observeSingleEvent(of: .value, with: {
//            (snap) in
//
//            let types = snap.value as? NSDictionary
//            completionHandler(types)
//
//        })
        
    }
    
    func loadIconsForDefaultTypes(type: String, completionHandler: @escaping ((Data?, Error?) -> ())) {
        
        let url = "default-card-icons/\(type).png"
        let storageRef = Storage.storage().reference().child(url)
        
        storageRef.getData(maxSize: 1 * 1024 * 1024, completion: completionHandler)
        
    }
    
    
    

}
