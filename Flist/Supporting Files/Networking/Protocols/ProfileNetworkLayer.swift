//
//  ProfileNetworkLayer.swift
//  Flist
//
//  Created by Роман Широков on 07/11/2018.
//  Copyright © 2018 Flist. All rights reserved.
//

import Foundation

protocol ProfileNetworkLayer : BaseLayerProtocol {
    
    // Callback: uid, info, groups, cards
    
    /**
     The callback type for returning the full profile icluding user id, account information, groups and cards.
     */
    typealias FullProfileCallback = ( (String?, NSDictionary?, NSDictionary?, NSDictionary?) -> () )
    
    // Retrieving full profile data
    
    /**
     Method accesses network in order to retrieve the full profile of the user with given id.
     
     - parameters:
        - userID: id of the the user.
        - completionHandler: callback returning the full profile of the user with given id.
     */
    func getFullProfileWith(userID: String, completionHandler: @escaping FullProfileCallback )
    
    /**
     Method accesses network in order to retrieve the full profile of the user with given id.
     - parameters:
         - username: username of the the user.
         - completionHandler: callback returning the full profile of the user with given id.
     */
    func getFullProfileWith(username: String, completionHandler: @escaping FullProfileCallback )
    
    // Retrieving specific parts of the profile
    
    /**
     Method accesses network in order to retrieve the account information of the user with given id.
     - parameters:
         - userID: id of the the user.
         - completionHandler: callback returning the account information of the user with given id.
     */
    func getProfileInfo (_ userID: String, completionHandler: @escaping ( (NSDictionary?) -> () ) )
    
    /**
     Method accesses network in order to retrieve the groups from the user's profile with given id.
     - parameters:
         - userID: id of the the user.
         - completionHandler: callback returning the groups from the user's profile with given id.
     */
    func getProfileGroups (_ userID: String, completionHandler: @escaping ( (NSDictionary?) -> () ) )
    
    /**
     Method accesses network in order to retrieve the cards from the user's profile with given id.
     - parameters:
         - userID: id of the the user.
         - completionHandler: callback returning the cards from the user's profile with given id.
     */
    func getProfileCards (_ userID: String, completionHandler: @escaping ( (NSDictionary?) -> () ) )
    
    // Retrieving a custom icon of the card from the storage
    
    /**
        Method accesses network in order to retrieve the custom icon of the specific card.
        - parameters:
            - uid: id of the the user.
            - card_id: id of the card.
            - completionHandler: callback returning the data that represents the requested card's icon and error if any.
     */
    func loadCustomCardIcon (uid: String, card_id: String, completionHandler: @escaping ((Data?, Error?) -> ()))


    func loadCardTypes (completionHandler: @escaping ((NSDictionary?) -> ()))
    
    func loadIconsForDefaultTypes(type: String, completionHandler: @escaping ((Data?, Error?) -> ()))
}
