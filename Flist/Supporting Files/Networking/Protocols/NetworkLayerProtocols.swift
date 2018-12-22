//
//  NetworkLayer.swift
//  Flist
//
//  Created by Роман Широков on 06/11/2018.
//  Copyright © 2018 Flist. All rights reserved.
//

import Foundation

protocol BaseLayerProtocol {
    
    /**
     - returns: the identificator of the active user. One of the uses is the verification of authorization; thus if returns nil, the user is not logged in.
     */
    func getCurrentUID() -> String?
}
