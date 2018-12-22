//
//  ProfileEditTableViewController.swift
//  Together
//
//  Created by Роман Широков on 01.11.17.
//  Copyright © 2017 Roman Sirokov. All rights reserved.
//

import UIKit

class ProfileEditTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

//    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var actionBtn: UIButton!
    
    @IBOutlet weak var imgView: UIImageView!
   
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var surnameField: UITextField!
    
    @IBOutlet weak var privacySegment: UISegmentedControl!
    
    @IBOutlet weak var descriptionField: UITextView!
    
    private var uploadIndView: UIActivityIndicatorView? // Indicator that will show the card upload proccess

    
    var isImgDefault = true
    
    var profile: ProfileInfoElement!
    
    func CustomInit(_ profile: ProfileInfoElement) {
        self.profile = profile
    }
    
    let model = AccountManagementModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SetupContent()
        SetupUploadCardIndicator()
        
    }
    
    private func SetupContent() {
        
        self.tableView.tableFooterView = UIView()
        
        imgView.roundView()
        imgView.image = profile.img
        
        nameField.text = profile.name
        surnameField.text = profile.surname
        
        descriptionField.text = profile.desc
        descriptionField.delegate?.textViewDidChange!(descriptionField)
        
    }
    
    private func SetupUploadCardIndicator() {
        
        let indicator = UIActivityIndicatorView(style: .whiteLarge)
        
        indicator.color = UIColor.mainColorTheme
        indicator.center = actionBtn.center
        
        uploadIndView = indicator
        self.actionBtn.superview?.addSubview(uploadIndView!)
        
    }
    
    private func SetActivityIndicatorState(_ state: Bool) {
        
        actionBtn.isHidden = state
        
        if state { uploadIndView?.startAnimating() }
        else { uploadIndView?.stopAnimating() }
        
    }
    
    @IBAction func UploadImageAction(_ sender: Any) {
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self

        
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: {
            
            (action) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePicker.sourceType = .camera;
                imagePicker.allowsEditing = false
                
                self.present(imagePicker, animated: true, completion: nil)

            }
            
        })
        
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default, handler: {
            (action) in
            
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                imagePicker.sourceType = .photoLibrary;
                imagePicker.allowsEditing = true
                
                self.present(imagePicker, animated: true, completion: nil)

            }

            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            
        })

        actionSheet.addAction(cameraAction)
        actionSheet.addAction(photoLibraryAction)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        
        
        if let img = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage {
            
            let reseizedImg = ProfileManageModel.ResizeImage(image: img, targetSize: CGSize(width: 225, height: 225))
            imgView.image = reseizedImg
            isImgDefault = false
                        
        } else if let img = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
            
            let reseizedImg = ProfileManageModel.ResizeImage(image: img, targetSize: CGSize(width: 225, height: 225))
            imgView.image = reseizedImg
            isImgDefault = false
            
            
        } else {
            
            print("UIImagePicker - Error")
            
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func SaveAction(_ sender: Any) {
        
        let descController = descriptionField as! DescriptionTextView
        
        if ( !descController.isAccaptable ) {
            ShowAlert(title: "Error", msg: "The description text field is over maximum length!", btn: "Cancel")
            return
        }
        
        
        SetActivityIndicatorState(true)
        
        let name = nameField.text
        let surname = surnameField.text
        let desc = descriptionField.text
    
    
        var data: [String: Any] = [:]

        data["name"] = name
        data["surname"] = surname
        data["description"] = desc
        
        if !isImgDefault {
            let imgURL = model.uploadProfileImage(img: imgView.image!, completionHandler: UploadDone(error:))
            data["img"] = imgURL
        }
        
        model.updateAccount(data: data)
        
        if isImgDefault {
            UploadDone(error: nil)
        }
        
    }
    
    func UploadDone (error: Error?) {
        
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    func ShowAlert(title: String, msg: String, btn: String){
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: btn, style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
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
