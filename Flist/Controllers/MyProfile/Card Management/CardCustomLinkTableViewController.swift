//
//  CardCustomLinkTableViewController.swift
//  Flist
//
//  Created by Роман Широков on 30.03.18.
//  Copyright © 2018 Flist. All rights reserved.
//

import UIKit

class CardCustomLinkTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    

    @IBOutlet weak var iconImg: UIImageView!
    @IBOutlet weak var linkField: UITextField!
    
    @IBOutlet weak var iconPickerBtn: UIButton!
    
    public var customExistingIcon: UIImage?
    public var customExistingLink: String?
    
    private var customIcon: UIImage?
    private var customLink: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        iconPickerBtn.SetBorder()
        
        if let ico = customExistingIcon { iconImg.image = ico }
        if let lnk = customExistingLink { linkField.text = lnk }
        
        self.tableView.tableFooterView = UIView()
    }
    
    @IBAction func DoneAction (_ sender: Any) {
        
        customLink = linkField.text

        if customLink == nil || (customLink?.isEmpty)! {
            
            self.ShowAlert(msg: "You cannot leave the link field empty!")
            return
            
        }
        
        if !NSURL.VerifyUrl(customLink) {
            
            self.ShowAlert(msg: "The URL is invalid!")
            return
            
        }
        
        if let viewControllers = self.navigationController?.viewControllers {
            
            let count = viewControllers.count
            
            if count > 1 {
                if let vc = viewControllers[count - 2] as? NewCardTableViewController {
                    vc.cardType = "none"
                    vc.linkToService = customLink
                    if let icon = customIcon { vc.customIconImg = icon }
                }
            }
            
        }
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    
    // MARK: Icon Image proccessing
    
    @IBAction func IconImgUploadAction(_ sender: Any) {
        

        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self

            
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
            
            self.present(imagePicker, animated: true, completion: nil)
            
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        
        
        if let img = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage {
            
            let reseizedImg = ProfileManageModel.ResizeImage(image: img, targetSize: CGSize(width: 225, height: 225))
            iconImg.image = reseizedImg
            customIcon = iconImg.image
            
        } else if let img = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
            
            let reseizedImg = ProfileManageModel.ResizeImage(image: img, targetSize: CGSize(width: 225, height: 225))
            iconImg.image = reseizedImg
            customIcon = iconImg.image
            
        } else {
            
            iconImg.image = ServiceModel.services[0].icon
            
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
