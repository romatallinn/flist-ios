//
//  ContactsTableViewCell.swift
//  Together
//
//  Created by Роман Широков on 07.07.17.
//  Copyright © 2017 Roman Sirokov. All rights reserved.
//

import UIKit

class SubscriptionsTableViewCell: UITableViewCell {

    var id: String = "0"
    var date: String = ""
    
    @IBOutlet weak var avatar: UIImageView!
    
    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var name: UILabel!

    @IBOutlet weak var verifiedImg: UIImageView!
    
    @IBOutlet weak var newBadge: UILabel!
    
    
}
