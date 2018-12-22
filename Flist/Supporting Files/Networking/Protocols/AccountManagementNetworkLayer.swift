//
//  AccountManagementNetworkLayer.swift
//  Flist
//
//  Created by Роман Широков on 07/11/2018.
//  Copyright © 2018 Flist. All rights reserved.
//

import Foundation

protocol AccountManagementNetworkLayer : BaseLayerProtocol {
    
    
    /**
     Method updates the email, of the active user, in the Firebase's DB.
     
     - parameters:
     - email: a string that represents new email.
     - completionHandler: callback that sends an Error object if any.
     */
    func updateEmail(_ to: String, completionHandler: @escaping ((Error?)->()))
    
    
    /**
     Method updates the password, of the active user, in the Firebase's DB.
     
     - parameters:
     - to: a string that represents new password.
     - completionHandler: callback that sends an Error object if any.
     */
    func updatePassword(_ to: String, completionHandler: @escaping ((Error?)->()))
    
    
    /**
     Method updates the name, of the active user, in the Firebase's DB.
     - parameter name: a string that represents new name.
     */
    func updateName(_ to: String)
    
    
    /**
     Method updates the surname, of the active user, in the Firebase's DB.
     - parameter surname: a string that represents new surname.
     */
    func updateSurname(_ to: String)
    
    /**
     Method updates the general profile information of the active user.
     - parameter data: dictionary that replaces the old general profile information.
     */
    func updateProfile(_ to: [String: Any])
    
    func uploadProfileImg(fileName: String, imgData: Data, completionHandler: @escaping ((Error?)->()))
    
    /**
     Method that sends the request to network to send reset password of the user with given email.
     - parameter withEmail: the email of the account that needs to be reset.
     */
    func requestPasswordReset(_ withEmail: String, completionHandler: @escaping ((Error?) -> ()))
    
}
