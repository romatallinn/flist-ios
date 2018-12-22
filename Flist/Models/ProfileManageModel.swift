//
//  ProfileManageModel.swift
//  Flist
//
//  Created by Роман Широков on 07/11/2018.
//  Copyright © 2018 Flist. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAnalytics

class ProfileManageModel {
    
    let networkLayer = NetworkLayer.profileManager
    
    public func addCard(_ data: [String : Any]) -> String {
        // Firebase Analytics -- Follow User event
        Analytics.logEvent("card_added", parameters: [
            "card_type": data["type"] ?? "UNKNOWN"
            ])
        
        return networkLayer.addCard(data)
    }
    
    public func addGroup(_ data: [String: Any]) {
        
        // Firebase Analytics -- Follow User event
        Analytics.logEvent("group_added", parameters: nil)
        
        networkLayer.addGroup(data)
    }
    
    public func updateCard(_ data: [String: Any]?, id: String) {
        networkLayer.updateCard(data, id: id)
    }
    
    public func updateGroup(_ data: [String: Any]?, id: String) {
        networkLayer.updateGroup(data, group_id: id)
    }
    
    public func updateProfile(_ data: [String : Any]) {
        networkLayer.updateProfile(data)
    }
    
    public func uploadCustomCardIcon(card_id: String, img: UIImage, completionHandler: @escaping (()->()) ) {
        
        // Firebase Analytics -- Follow User event
        Analytics.logEvent("custom_card_icon_uploaded", parameters: nil)
        
        let fileName = card_id + ".jpg"
        let data = img.jpegData(compressionQuality: 1)

        networkLayer.uploadCustomCardIcon(fileName: fileName, imgData: data!, completionHandler: completionHandler)
    }
    
    public static func ResizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        
        var posX: CGFloat
        var posY: CGFloat
        
        let min = size.width < size.height ? size.width : size.height
        
        posY = 0
        posX = 0
        
        let img = image.crop(rect: CGRect(x: posX, y: posY, width: min, height: min))
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: targetSize.width, height: targetSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(targetSize, false, 1.0)
        img.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
        
    
}
