//
//  NetworkLayer.swift
//  Flist
//
//  Created by Роман Широков on 07/11/2018.
//  Copyright © 2018 Flist. All rights reserved.
//

import Foundation

class NetworkLayer {
    
    
    // CHANGE THESE SETTINGS IF ANOTHER NETWORK LAYER IS USED!
    
    
    /// The network layer that provides funcionality in handling procedures needed in authorization.
    static let auth: AuthNetworkLayer = FirebaseAuthNetworkLayer()
    
    /// The network layer that provides funcionality in handling procedures needed in account management (e.g., updating acc info).
    static let account: AccountManagementNetworkLayer = FirebaseAccountManagementNetworkLayer()
    
    /// The network layer that provides funcionality in accessing profile data.
    static let profile: ProfileNetworkLayer = FirebaseProfileNetworkLayer()
    
    /// The network layer that provides funcionality in profile data management and updating.
    static let profileManager: ProfileManagementNetworkLayer = FirebaseProfileManagementNetworkLayer()
    
}
