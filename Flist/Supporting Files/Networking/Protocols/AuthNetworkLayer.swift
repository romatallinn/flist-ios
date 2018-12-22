//
//  AuthNetworkLayer.swift
//  Flist
//
//  Created by Роман Широков on 07/11/2018.
//  Copyright © 2018 Flist. All rights reserved.
//

import Foundation


protocol AuthNetworkLayer : BaseLayerProtocol {
    
    typealias LayerAuthResultCallback = ( (String?, Error?) -> () )
    
    // Authentication layer
    
    func getUserEmail() -> String
    
    /**
     - returns: FCM toke of the device for the push notification purposes.
     */
    func getFCMToken() -> String?
    
    /**
     The user with the given credentials is getting authorized.
     
     - parameters:
     - email: The inputted user's email param
     - password: The inputted user's password param
     - completionHandler: AuthResultCallback returning 'user' and/or 'error'
     */
    func authorization(email: String, password: String, completionHandler: @escaping LayerAuthResultCallback)
    
    /**
     The user with the given credentials is getting registered using the initial set of parameters. Eventually, the method sends an email verification letter to the user.
     
     - parameters:
     - username: The inputted user's username param
     - password: The inputted user's password param
     - email: The inputted user's email param
     - completionHandler: AuthResultCallback returning 'user' and/or 'error'
     */
    func registration(username: String, password: String, email: String, completionHandler: @escaping LayerAuthResultCallback)
    
    /**
     Registers the device token for Push Notifications if a new one was generated
     - parameter token: a string that represents the token of the device for push notification purposes.
     */
    func addFCMToken(token: String?)
    
    /**
     Method closes the active session in Firebase's Auth, thus logouts the user.
     */
    func logout() throws
    
    // Retrieving the general profile information
    
    /**
     Method accesses network in order to retrieve the account information of the user with given id.
     - parameters:
        - completionHandler: callback returning the account information of the user with given id.
     */
    func getUserProfileInfo(completionHandler: @escaping ((NSDictionary?)->()))
    
    /**
     Method accesses network in order to retrieve the user's profile image.
     - parameters:
         - id: id of the the user.
         - completionHandler: callback returning the data that represents the requested card's icon and error if any.
     */
    func getUserProfileImage(_ id: String?, completionHandler: @escaping ((Data?, Error?) -> ()))
}
