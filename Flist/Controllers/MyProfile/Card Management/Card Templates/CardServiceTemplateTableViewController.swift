//
//  CardServiceTemplateTableViewController.swift
//  Flist
//
//  Created by Роман Широков on 31.03.18.
//  Copyright © 2018 Flist. All rights reserved.
//

import UIKit

class CardServiceTemplateTableViewController: UITableViewController {

    @IBOutlet weak var serviceIconImg: UIImageView!
    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var urlLabel: UILabel!
    
    private var serviceType: String = "none"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let service = ServiceModel.getTypeByShortcut(serviceType)
        
        serviceIconImg.image = service.icon
        serviceName.text = service.name
        
        urlLabel.text = service.link + "username"
        
        self.tableView.tableFooterView = UIView()
    }
    
    public func InitializeTemplate (type: String!) { serviceType = type }
    
    @IBAction func UsernameFieldChangedAction(_ sender: Any) {
        if let username = usernameField.text {
            urlLabel.text = ServiceModel.getTypeByShortcut(serviceType).link + username
        }
    }
    
    @IBAction func DoneAction (_ sender: Any) {
        
        if (usernameField.text?.isEmpty)! {
            self.ShowAlert(msg: "Username field cannot be empty!")
            return
        }
        
        
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        
        let username = usernameField.text
        let url = urlLabel.text
        
        let controller = viewControllers[viewControllers.count - 3] as! NewCardTableViewController
        controller.cardType = serviceType
        controller.linkToService = url
        controller.usernameToService = username
        
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
    }
    

}
