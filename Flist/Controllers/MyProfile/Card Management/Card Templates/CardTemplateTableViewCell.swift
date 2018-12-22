//
//  CardTemplateTableViewCell.swift
//  Flist
//
//  Created by Роман Широков on 31.03.18.
//  Copyright © 2018 Flist. All rights reserved.
//

import UIKit

class CardTemplateTableViewCell: UITableViewCell {

    public var tmpType: String?
    
    @IBOutlet weak var iconImg: UIImageView!
    @IBOutlet weak var serviceNameLabel: UILabel!
    
    public func InitializeCell(tmpType: String) {
        
        self.tmpType = tmpType
        
        let service = ServiceModel.getTypeByShortcut(tmpType)
        
        self.iconImg.image = service.icon
        self.serviceNameLabel.text = service.name
        
    }
}
