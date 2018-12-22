//
//  ExpandableHeaderView.swift
//  Flist
//
//  Created by Роман Широков on 05.11.17.
//  Copyright © 2017 Flist. All rights reserved.
//

import UIKit

protocol ExpandableHeaderViewDelegate {
    func toggleSection(header: ExpandableHeaderView, section: Int)
}

class ExpandableHeaderView: UITableViewHeaderFooterView, MainGradientProtocol, ProfileCellProtocol {

    var group: CardGroup!
    
    var delegate: ExpandableHeaderViewDelegate?
    var section: Int!
    
    var isOwned: Bool!
    var viewController: UIViewController!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func customInit(title: String, group: CardGroup, section: Int, delegate: ExpandableHeaderViewDelegate, viewController: UIViewController) {
        self.textLabel?.text = title
        self.group = group
        self.section = section
        self.delegate = delegate
        self.viewController = viewController
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(TapAction)))
        
        if isOwned {
            self.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(LongPressAction)))
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let gradient = self.getHorizontalGradientLayer()
        gradient.frame = self.bounds
        
        self.contentView.layer.insertSublayer(gradient, at: 0)
        
        self.textLabel?.textColor = UIColor.white
        self.contentView.backgroundColor = UIColor.blue
        
    }
    
    @objc func TapAction(gestureRecognizer: UITapGestureRecognizer) {
        
        let cell = gestureRecognizer.view as! ExpandableHeaderView
        delegate?.toggleSection(header: self, section: cell.section)
        
    }
    
    @objc func LongPressAction(longPressRecognizer: UILongPressGestureRecognizer){
        
        if !isOwned || group.id == "0" {
            return
        }
        
        // 1
        let optionMenu = UIAlertController(title: "Manage Group", message: nil, preferredStyle: .actionSheet)
        
        let editAction = UIAlertAction(title: "Edit", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            self.viewController.performSegue(withIdentifier: "EditGroup", sender: self)
            
        })
        optionMenu.addAction(editAction)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: {
            (alert: UIAlertAction!) -> Void in
            
            self.DeleteAlert()
            
        })
        optionMenu.addAction(deleteAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            
            
        })
        optionMenu.addAction(cancelAction)
        
        
        viewController.present(optionMenu, animated: true, completion: nil)
    
    }
    
    func DeleteAlert(){
        
        let alertController = UIAlertController(title: "Delete this group?", message: "This group will be deleted.", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Delete", style: .destructive) { (_) in
            
            let model = ProfileManageModel()
            model.updateGroup(nil, id: self.group.id)
            
            if let table = self.viewController as? ProfileViewProtocol {
                table.TableViewLoadData()
            }
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        viewController.present(alertController, animated: true, completion: nil)
        
    }
    
}
