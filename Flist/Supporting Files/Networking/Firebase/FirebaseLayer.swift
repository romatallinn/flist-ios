//
//  FirebaseLayer.swift
//  Flist
//
//  Created by Роман Широков on 06/11/2018.
//  Copyright © 2018 Flist. All rights reserved.
//

import FirebaseAuth
import FirebaseDatabase

class FirebaseLayer: BaseLayerProtocol {
        
    internal let ref = Database.database().reference()
    public func getCurrentUID() -> String? { return Auth.auth().currentUser?.uid }

}
