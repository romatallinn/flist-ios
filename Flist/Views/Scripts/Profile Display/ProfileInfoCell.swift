//
//  ProfileInfoCell.swift
//  Flist
//
//  Created by Роман Широков on 05.11.17.
//  Copyright © 2017 Flist. All rights reserved.
//

import UIKit

class ProfileInfoCell: ProfileTableViewCell, MainGradientProtocol {
    
    var info: ProfileInfoElement!
    @IBOutlet weak var verifiedImg: UIImageView!

    
    override func layoutSubviews() {

        super.layoutSubviews()
        self.contentView.layoutSubviews()
        viewCont.layoutSubviews()
        
        logoImg.roundView()
        
        viewCont.layer.shadowOpacity = 1

        
//        let gradient = self.getLightGradientLayer()
//        gradient.frame = viewCont.layer.frame
//        viewCont.layer.insertSublayer(gradient, at: 0)
        
    }
    
    func CustomInit(_ info: ProfileInfoElement?, isOwned: Bool, viewController: UIViewController) {
        
        if let inf = info {
        
            self.info = inf
            
            self.isOwned = isOwned
            
            logoImg.isSkeletonable = false
            name.isSkeletonable = false
            descript.isSkeletonable = false
            user.isSkeletonable = false

            verifiedImg.isHidden = !inf.verified
            logoImg.image = inf.img
            name.text = inf.displayFullName
            
            let paragraphStyle = NSMutableParagraphStyle()
            
            paragraphStyle.lineSpacing = 4
            
            let attrString = NSMutableAttributedString(string: inf.displayDescription)
            
            attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
            
            descript.attributedText = attrString
            
            descript.textAlignment = NSTextAlignment.left
            
//            descript.text = inf.displayDescription
            
            user.text = inf.displayUsername
            
        } else {
            
            verifiedImg.isHidden = true
            
            logoImg.isSkeletonable = true
            logoImg.showAnimatedGradientSkeleton(usingGradient: skeletonGradient)
            
            name.isSkeletonable = true
            name.showAnimatedGradientSkeleton(usingGradient: skeletonGradient)
            
            descript.isSkeletonable = true
            descript.showAnimatedGradientSkeleton(usingGradient: skeletonGradient)
            
            user.isSkeletonable = true
            user.showAnimatedGradientSkeleton(usingGradient: skeletonGradient)
            
        }
            
            self.viewController = viewController
            
        
        
    }
    
    override func LongPressAction(longPressRecognizer: UILongPressGestureRecognizer) {
        
        
        // 1
        let optionMenu = UIAlertController(title: "Manage Profile Information", message: nil, preferredStyle: .actionSheet)
        
        
        let shareAction = UIAlertAction(title: "Share", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            // set up activity view controller
            let stringToShare = [ ProfileModel.ProfileWebURL + self.info.username ]
            let activityViewController = UIActivityViewController(activityItems: stringToShare, applicationActivities: nil)
            
            // exclude some activity types from the list (optional)
            activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.addToReadingList, UIActivity.ActivityType.airDrop, UIActivity.ActivityType.assignToContact, UIActivity.ActivityType.openInIBooks, UIActivity.ActivityType.postToVimeo, UIActivity.ActivityType.saveToCameraRoll, UIActivity.ActivityType.print ]
            
            // present the view controller
            self.viewController.present(activityViewController, animated: true, completion: nil)
            
            
        })
        optionMenu.addAction(shareAction)

        if isOwned {
            
            let editAction = UIAlertAction(title: "Edit", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                
                self.viewController.performSegue(withIdentifier: "EditProfile", sender: self)
                
            })
            optionMenu.addAction(editAction)
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            
        })
        optionMenu.addAction(cancelAction)
        
        viewController.present(optionMenu, animated: true, completion: nil)
        
    }

    
}
