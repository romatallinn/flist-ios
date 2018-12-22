//
//  NewGroupViewController.swift
//  Flist
//
//  Created by Роман Широков on 28.09.17.
//  Copyright © 2017 Flist. All rights reserved.
//

import UIKit

class NewGroupTableViewController: UITableViewController {


    let model = ProfileManageModel()
    
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var privacyPicker: UISegmentedControl!
    @IBOutlet weak var actionButton: UIButton!
    
    var groupToEdit: CardGroup?
    
    var isEdit: Bool {
        
        return groupToEdit != nil
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isEdit {
            self.navigationItem.title = "Edit Group"
            actionButton.setTitle("Save", for: .normal)
            
            nameField.text = groupToEdit?.name
        }
        
    }
    
    @IBAction func CreateAction(_ sender: Any) {
        
        let data = [
            "name": nameField.text!
            //TODO: Add Privacy handler
        ]
        
        if isEdit {
            model.updateGroup(data, id: (groupToEdit?.id)!)
        } else {
            model.addGroup(data)
        }
        
        
        if let viewControllers = self.navigationController?.viewControllers {
            
            let count = viewControllers.count
            
            if count > 1 {
                if let vc = viewControllers[count - 2] as? MyProfileViewController {
                    vc.TableViewLoadData()
                }
            }
            
        }
        
        _ = self.navigationController?.popViewController(animated: true)
        
        
    }

}
