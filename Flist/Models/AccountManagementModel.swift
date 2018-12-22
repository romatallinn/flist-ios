//
//  AccountManagementModel.swift
//  Flist
//
//  Created by Роман Широков on 07/11/2018.
//  Copyright © 2018 Flist. All rights reserved.
//

import Foundation
import UIKit

class AccountManagementModel {
    
    let networkLayer = NetworkLayer.account
    
    public func updateEmail(_ to: String, completionHandler: @escaping ((Error?)->())) {
        networkLayer.updateEmail(to, completionHandler: completionHandler)
    }
    
    public func updatePassword(to: String, completionHandler: @escaping ((Error?)->())) {
        networkLayer.updatePassword(to, completionHandler: completionHandler)
    }
    
    public func updateName(to: String) {
        networkLayer.updateName(to)
    }
    
    public func updateSurname(to: String) {
        networkLayer.updateSurname(to)
    }
    
    public func updateAccount(data: [String: Any]) {
        networkLayer.updateProfile(data)
    }
    
    public func requestPasswordReset(withEmail: String, completionHandler: @escaping ((Error?)->())) {
        networkLayer.requestPasswordReset(withEmail, completionHandler: completionHandler)
    }

    public func uploadProfileImage(img: UIImage, completionHandler: @escaping ((Error?)->())) -> String {
        
        let fileName = networkLayer.getCurrentUID()! + ".jpg"
        let data = img.jpegData(compressionQuality: 1)
        
        networkLayer.uploadProfileImg(fileName: fileName, imgData: data!, completionHandler: completionHandler)

        return fileName
    }
    
}
