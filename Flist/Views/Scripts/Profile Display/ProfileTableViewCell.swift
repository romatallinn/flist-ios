//
//  ProfileTableViewCell.swift
//  Flist
//
//  Created by Роман Широков on 05.11.17.
//  Copyright © 2017 Flist. All rights reserved.
//

import UIKit
import SkeletonView

protocol ProfileCellProtocol {
    func LongPressAction(longPressRecognizer: UILongPressGestureRecognizer)
    var isOwned: Bool! { get set }
    var viewController: UIViewController! { get set }
}


class ProfileTableViewCell: UITableViewCell, ProfileCellProtocol {
    
    @IBInspectable var shadowClr: UIColor = UIColor.black
    
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var user: UILabel!
    @IBOutlet weak var descript: UILabel!
    @IBOutlet weak var viewCont: UIView!
    
    var isOwned: Bool!
    var viewController: UIViewController!
    
    let skeletonGradient = SkeletonGradient(baseColor: UIColor.turquoise.withAlphaComponent(0.25), secondaryColor: UIColor.turquoise.withAlphaComponent(0.5))

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(LongPressAction)))
        
        viewCont.layer.shadowColor = shadowClr.cgColor
        viewCont.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        viewCont.layer.shadowRadius = 3
        
    }
    
    @objc func LongPressAction(longPressRecognizer: UILongPressGestureRecognizer) {
        // Overrided in subclasses
    }
    

}
