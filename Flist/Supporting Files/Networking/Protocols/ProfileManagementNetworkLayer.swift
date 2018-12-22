//
//  ProfileManagementNetworkLayer.swift
//  Flist
//
//  Created by Роман Широков on 07/11/2018.
//  Copyright © 2018 Flist. All rights reserved.
//

import Foundation

protocol ProfileManagementNetworkLayer : BaseLayerProtocol {
    
    // Retrieving the list of available templates for the cards
    
    /**
     Method returns through the callback the list of the available templates for the cards.
     - parameter completionHandler: returns the NSDictionary of the available templates.
     */
    func getCardTemplates(completionHandler: @escaping ( (NSDictionary?) -> () ))
    
    
    // Creation
    
    /**
     Method adds a card with the given data into the Firebase's DB.
     - parameter data: dictionary that needs to be added to the database as a card.
     - returns: a unique string identificator of the card.
     */
    func addCard(_ data: [String: Any]) -> String
    
    
    /**
     Method adds a group with the given data into the Firebase's DB.
     - parameter data: dictionary that needs to be added to the database as a group.
     - returns: a unique string identificator of the group.
     */
    func addGroup(_ data: [String: Any])
    
    // Updating
    
    /**
     Method updates the card of the given id with the given data.
     - parameters:
     - data: dictionary that needs to be added to the database as a card.
     - id: card's identificator that refers to the one that needs to be updated.
     */
    func updateCard(_ data: [String: Any]?, id: String)
    
    /**
     Method updates the group of the given id with the given data.
     - parameters:
     - data: dictionary that needs to be added to the database as a card.
     - group_id: group's identificator that refers to the one that needs to be updated.
     */
    func updateGroup(_ data: [String: Any]?, group_id: String)
    
    
    /**
     Method updates the general profile information of the active user.
     - parameter data: dictionary that replaces the old general profile information.
     */
    func updateProfile(_ data: [String: Any])
    
    
    func uploadCustomCardIcon (fileName: String, imgData: Data, completionHandler: @escaping (()->()) )
    
}
