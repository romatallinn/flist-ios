//
//  ProfileElementCell.swift
//  Flist
//
//  Created by Роман Широков on 05.11.17.
//  Copyright © 2017 Flist. All rights reserved.
//

import UIKit

class ProfileElementCell: ProfileTableViewCell {
        
    var url: String!
    var element: CardElement!

    let model = ProfileManageModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewCont.layer.shadowColor = shadowClr.cgColor
        viewCont.layer.shadowOpacity = 0.5
        viewCont.layer.cornerRadius = 10
        
    }
    
    func CustomInit(_ element: CardElement?, isOwned: Bool, viewController: UIViewController) {
        
        if let elem = element {
        
        self.isOwned = isOwned
        self.element = elem
        
        logoImg.isSkeletonable = false
//        descript.isSkeletonable = false

            
        logoImg.image = elem.img
        name.text = elem.name
//        descript.text = elem.desc
        user.text = elem.displayUsername
            
        self.url = elem.url
        
        } else {
            
            logoImg.isSkeletonable = true
            logoImg.showAnimatedGradientSkeleton(usingGradient: skeletonGradient)
            
//            descript.isSkeletonable = true
//            descript.showAnimatedGradientSkeleton(usingGradient: skeletonGradient)
            
            name.isHidden = true
            user.isHidden = true
            
        }
        
        self.viewController = viewController
            
        
    }
    
    override func LongPressAction(longPressRecognizer: UILongPressGestureRecognizer) {
        
        // 1
        let optionMenu = UIAlertController(title: "Manage Element", message: nil, preferredStyle: .actionSheet)
        
        // 2
        let copyAction = UIAlertAction(title: "Share", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            // set up activity view controller
            let stringToShare = [ self.url! ]
            let activityViewController = UIActivityViewController(activityItems: stringToShare, applicationActivities: nil)
            
            // exclude some activity types from the list (optional)
            activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.addToReadingList, UIActivity.ActivityType.airDrop, UIActivity.ActivityType.assignToContact, UIActivity.ActivityType.openInIBooks, UIActivity.ActivityType.postToVimeo, UIActivity.ActivityType.saveToCameraRoll, UIActivity.ActivityType.print ]
            
            // present the view controller
            self.viewController.present(activityViewController, animated: true, completion: nil)
            
            
            
        })
        optionMenu.addAction(copyAction)
        
        if isOwned {
        
            let editAction = UIAlertAction(title: "Edit", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
                self.viewController.performSegue(withIdentifier: "EditCard", sender: self)
            
            })
            
            optionMenu.addAction(editAction)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: {
                (alert: UIAlertAction!) -> Void in
                
                self.DeleteAlert()
                
            })
            
            optionMenu.addAction(deleteAction)
            
        }
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            
        })
        optionMenu.addAction(cancelAction)
        
        viewController.present(optionMenu, animated: true, completion: nil)
    }
    
    func DeleteAlert(){
        
        let alertController = UIAlertController(title: "Delete this card?", message: "This card will be deleted.", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Delete", style: .destructive) { (_) in
            
            self.model.updateCard(nil, id: self.element.id)

            if let table = self.viewController as? ProfileViewProtocol {
                table.TableViewLoadData()
            }
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        viewController.present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func PopupDescription(_ sender: Any) {
        
        if let popup = StoryboardController.getInitialController(withBoardID: "CardDescriptionPopup") as? ProfileCardDescriptionPopupViewController {
        
            popup.modalPresentationStyle = .overFullScreen
            viewController.present(popup, animated: false)
            popup.descriptionLabel.text = self.element.desc
            

            
        }
        
    }
    
}
