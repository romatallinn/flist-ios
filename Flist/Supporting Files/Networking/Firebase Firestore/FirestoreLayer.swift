//
//  FirestoreLayer.swift
//  Flist
//
//  Created by Roman Sirokov on 01/02/2019.
//  Copyright © 2019 Flist. All rights reserved.
//

import FirebaseAuth
import FirebaseFirestore

class FirestoreLayer: BaseLayerProtocol {
    
    internal let db = Firestore.firestore()
    public func getCurrentUID() -> String? { return Auth.auth().currentUser?.uid }

}
