//
//  Structs.swift
//  Flist
//
//  Created by Роман Широков on 22.04.2018.
//  Copyright © 2018 Flist. All rights reserved.
//

import UIKit

/// Full Profile of the user.
/// Including: user's info (username, name, desc, photo) and all his groups with cards
struct ProfileFull {
    
    var info: ProfileInfoElement
    var cardGroups: [CardGroup]
    
}

/// Struct that represents a group of cards
struct CardGroup {
    
    var name : String! 
    var cards = [CardElement]()
    var id: String = "0"
    var expanded: Bool = false
    
    init(_ data: [String: Any]) {
        
        self.name = data["name"] as? String
        self.id = data["id"] as! String
        
    }
    
}

// General protocol for profile elemets
// Elements like profile info element and cards, have username and description
protocol ProfileElementProtocol {
    
    var username: String { get set }
    var desc: String { get set }
    
    var displayUsername: String { get }
    
}

/// Profile Info Element --- user's profile information
struct ProfileInfoElement: ProfileElementProtocol {
    
    var img: UIImage
    
    var verified: Bool
    
    var username: String
    var username_lowercased: String
    
    var desc: String
    
    var name: String
    var surname: String
    
    var displayFullName: String {
        return "\(name) \(surname)"
    }

    var displayUsername: String {
        return "@ \(username)"
    }
    
    var displayDescription: String {
        return (desc.isEmpty) ? "No Description..." : desc
    }
    
    init(_ data: NSDictionary) {
        
        self.img = #imageLiteral(resourceName: "avatar")
        
        self.verified = (data["verified"] as? Bool) ?? false
        
        self.username = (data["username"] as? String) ?? ""
        self.username_lowercased = (data["username_lowercased"] as? String) ?? ""
        
        self.desc = (data["description"] as? String) ?? ""
        
        self.name = (data["name"] as? String) ?? ""
        self.surname = (data["surname"] as? String) ?? ""
        
    }
    
}

/// Card Element --- a single card entity
struct CardElement: ProfileElementProtocol {
    
    var id : String!
    
    var name : String
    var group_id : String
    
    var type : String
    var img : UIImage
    var url : String
    
    var username: String
    var desc: String
    
    var displayUsername: String {
        return username
    }
    
    init(_ data: [String: Any], id: String!) {
        
        self.id = id
        
        self.name = (data["name"] as? String) ?? ""
        self.group_id = (data["group_id"] as? String) ?? "0"

        self.type = (data["type"] as? String) ?? "none"
        self.img = ServiceModel.getTypeByShortcut(self.type).icon
        self.url = (data["url"] as? String) ?? "https://flist.me"
        
        self.username = (data["username"] as? String) ?? ""
        self.desc = (data["description"] as? String) ?? ""
        
    }
    
}

/// Element that represents a signle service entity
struct ServiceListElement {
    
    var name: String
    var shortcut: String
    var icon: UIImage
    var link: String
    
}
