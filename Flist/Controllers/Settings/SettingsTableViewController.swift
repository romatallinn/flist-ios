//
//  SettingsTableViewController.swift
//  Together
//
//  Created by Роман Широков on 06.07.17.
//  Copyright © 2017 Roman Sirokov. All rights reserved.
//

import UIKit
import Firebase

class SettingsTableViewController: UITableViewController {
    
    // Credential fields
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var pLinkLabel: UILabel!
    

    // Authentication model
    let authModel = AuthModel()
    let accModel = AccountManagementModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // If user is authenticated
        if authModel.isAuth() {
        
            // Get his profile info
            authModel.getUserProfileInfo() {
                (account) in
        
                guard let account = account else { return }
                
                // Setup credential fields
                self.usernameField.text = account.username
                self.pLinkLabel.text = ProfileModel.ProfileWebURL + account.username
                self.emailField.text = self.authModel.getUserEmail()
            
            }
        }
            
        
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let row = indexPath.row
        
        if indexPath.section == 0 {
            switch row {
                
                case 0:
                    break

                case 1: // Username
                    break
                
                case 2: // Email
                    UpdateEmailAction()
                
                case 3: // Password
                    UpdatePasswordAction()
                
                case 4:
                    LogoutAction()
                
                default: break
            }
        } else if indexPath.section == 1 {
            
            switch row {
                
                case 0: // Permissions
                    PermissionsAction()
                    break
                
                case 1: // Support
                    break
                
                case 2: // Terms & Privacy
                    break
                
                case 3: // About
                    break
                

                default: break
                
            }
            
        } else { // Debugging
            
            switch row {
                case 0: // Reset NSDefaults
                    ResetNSDefaults()
                    break
                
                default:
                    break
            }
            
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    
    func UpdateEmailAction() {
    
        let alertController = UIAlertController(title: "Update Email?", message: "Please input your email:", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
            
            if let emailTxt = alertController.textFields![0].text  {
                
                self.accModel.updateEmail(emailTxt, completionHandler: {
                
                    (error) in
                    
                    if let err = error {
                        
                        self.ShowAlert(msg: err.localizedDescription)
                    
                    } else {
                    
                        self.emailField.text = emailTxt
                        
                    }
                    
                    
                
                })

                
            }

            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Email"
        }
        
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    
    }
    
    func UpdatePasswordAction() {
    
        let alertController = UIAlertController(title: "Update Password?", message: "Please input your new password:", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
           
             if let aField = alertController.textFields![0].text, let bField = alertController.textFields![1].text  {
             
                if aField == bField {
                    self.accModel.updatePassword(to: aField, completionHandler: {
                        (error) in
                        
                        if let err = error {
            
                                
                            self.ShowAlert(msg: err.localizedDescription)
                            
                        }
                        
                    })
                } else {
                
                    self.ShowPasswordError(msg: "The passwords does not match!")
                    
                }
                
            }
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alertController.addTextField { (textField) in
            textField.isSecureTextEntry = true
            textField.placeholder = "Password"
        }
        
        alertController.addTextField { (textField) in
            textField.isSecureTextEntry = true
            textField.placeholder = "Repeat Password"
        }
        
        
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func LogoutAction() {
        
        authModel.logout()
        
        self.present(StoryboardController.getInitialController(withBoardID: "Auth"), animated: true, completion: nil)

    }
    
    func PermissionsAction() {
        
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (_) in })
        }
        
    }
    
    func ResetNSDefaults() {

        let alert = UIAlertController(title: "Reset Storage", message: "Are you sure that you want to reset all data?", preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Reset", style: UIAlertAction.Style.destructive, handler: {

            (action) in

            let domain = Bundle.main.bundleIdentifier!
            UserDefaults.standard.removePersistentDomain(forName: domain)
            UserDefaults.standard.synchronize()

        }))

        alert.addAction( UIAlertAction(title: "Cancel", style: .cancel, handler: nil) )


        self.present(alert, animated: true, completion: nil)
    }
    
    func ShowPasswordError(msg: String) {
    
        let alert = UIAlertController(title: "Error", message: msg, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: {
            
            (action) in
            
            self.UpdatePasswordAction()
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    
    }
    
    @IBAction func copyLinkAction(_ sender: Any) {
        
        
        
        // set up activity view controller
        let stringToShare = [ self.pLinkLabel.text! ]
        let activityViewController = UIActivityViewController(activityItems: stringToShare, applicationActivities: nil)
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.addToReadingList, UIActivity.ActivityType.airDrop, UIActivity.ActivityType.assignToContact, UIActivity.ActivityType.openInIBooks, UIActivity.ActivityType.postToVimeo, UIActivity.ActivityType.saveToCameraRoll, UIActivity.ActivityType.print ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
        
    }

    @IBAction func unwindToThis(_ segue: UIStoryboardSegue) {
    
    }
    
}
