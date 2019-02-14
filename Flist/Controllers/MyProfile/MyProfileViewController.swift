//
//  MyProfileViewController.swift
//  Flist
//
//  Created by Роман Широков on 05.11.17.
//  Copyright © 2017 Flist. All rights reserved.
//

import UIKit

class MyProfileViewController: ProfileViewController, ProfileViewProtocol, UITableViewDataSource, UITableViewDelegate, ExpandableHeaderViewDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isOwned = true
        
        tableView.delegate = self
        tableView.dataSource = self
        
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.mainColorTheme
        tableView.addSubview(refreshControl)

        
        TableViewLoadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // TableViewLoadData()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if refreshControl.isRefreshing && !isUpdating{
    
            TableViewLoadData()
        
        }
    }
    
    
    let authModel = AuthModel()
    
    func TableViewLoadData() {
    
        isUpdating = true
        fullProfile = nil
    
        
        model.getFullProfileWith() {
            
            (_, info, groups, cards) in
            
            DispatchQueue.main.async {
                


                let profInfo = ProfileInfoElement(info!)
                
                self.authModel.getUserProfileImage() {
                    (img) in
                    
                    guard let img = img else { return }
                    
                    self.fullProfile?.info.img = img
                    
                    self.tableView.reloadRows(at: [IndexPath.init(row: 0, section: 0)], with: UITableView.RowAnimation.automatic)
                    
                }
                
                var sections = [CardGroup]()
                
                var initGroup : [String: Any]? = nil
                
                
                if let grps = groups {
                    for (key, value) in grps {
                    
                        var val = value as! [String: Any]
                    
                        let group_id = key as! String
                        val["id"] = group_id
                                        
                        sections.append(CardGroup(val))
                    
                    
                    }
                }
                
                if let profs = cards {
                    
                    for (key, value) in profs {
                    
                        let valArr = value as! [String: Any]
                        let group_id = valArr["group_id"] as! String

                        var index: Int
                        
                        if let i = sections.index(where: { $0.id == group_id }) {
                            
                            index = i
                            sections[i].cards.append(CardElement(valArr, id: key as? String))
                            
                        
                        } else {
                            
                            if initGroup == nil {
                                
                                initGroup = ["name" : " ", "id": "0"]
                                sections.insert(CardGroup(initGroup!), at: 0)
                                
                            }
                            
                            index = 0
                            
                            sections[0].cards.append(CardElement(valArr, id: key as? String))
                        }
              
                        
                        
                        let profs = sections[index].cards
                        
                        if let last = profs.last, let l_id = last.id, last.type == "none" {
                        
                            
                            self.model.loadCustomCardIcon(card_id: l_id) {
                                (image) in
                                
                                if sections[0].id == "0" {
                                    index += 1
                                }
                                
                                self.fullProfile?.cardGroups[index].cards[profs.count-1].img = image
                                self.tableView.reloadRows(at: [IndexPath.init(row: profs.count-1, section: index+1)], with:     UITableView.RowAnimation.automatic)
                            }
                            
                        }
                    
                    }
                }

            
                self.fullProfile = ProfileFull(info: profInfo, cardGroups: sections)
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
                self.isUpdating = false
                
                
            }
        }
    
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if(indexPath.row == 0) {
            return false
        }
        
        return true
    }
    
    
    func toggleSection(header: ExpandableHeaderView, section: Int) {
        
        if section == 0 {
            return
        }
        
        let newState = !((fullProfile?.cardGroups[section-1].expanded)!)
        fullProfile?.cardGroups[section-1].expanded = newState
        
        
        tableView.beginUpdates()
        
        for i in 0 ..< (fullProfile?.cardGroups[section-1].cards.count)! {
            tableView.reloadRows(at: [IndexPath(row: i, section: section)], with: .automatic)
        }
        
        tableView.endUpdates()
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(indexPath.section == 0) {
            
            if indexPath.row == 0 {
                let cell = Bundle.main.loadNibNamed(profileInfoNib, owner: self, options: nil)?.first as! ProfileInfoCell
                
                if let info = fullProfile?.info {
                
                    cell.CustomInit(info, isOwned: true, viewController: self)
                
                } else {
                    
                    cell.CustomInit(nil, isOwned: true, viewController: self)
                    
                }
                
                return cell

            } else if fullProfile?.cardGroups.count == 0 {
                let cell = Bundle.main.loadNibNamed(emptyPlaceholderNib, owner: self, options: nil)?.first as! UITableViewCell
                
                return cell
            }
            
        }
        
        
        let cell = Bundle.main.loadNibNamed(profileListNib, owner: self, options: nil)?.first as! ProfileElementCell
        
        let row = indexPath.row
        let sec = indexPath.section-1
        
        
        if let element = (fullProfile?.cardGroups[sec].cards[row]) {
            cell.CustomInit(element, isOwned: true, viewController: self)
        } else {
            cell.CustomInit(nil, isOwned: true, viewController: self)
        }
        
        return cell
    }
    
    @IBAction func AddElement(_ sender: Any) {
        
        // 1
        let optionMenu = UIAlertController(title: "New Element", message: nil, preferredStyle: .actionSheet)
        
        let profileAction = UIAlertAction(title: "Manage Profile", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            self.displayProfileMenu()
            
        })

        let elementAction = UIAlertAction(title: "Manage Elements", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            self.displayElementMenu()
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        
        
        optionMenu.addAction(profileAction)
        optionMenu.addAction(elementAction)

        optionMenu.addAction(cancelAction)
        
        // 5
        self.present(optionMenu, animated: true, completion: nil)
        
    }

    func displayElementMenu() {

        let optionMenu = UIAlertController(title: "New Element", message: nil, preferredStyle: .actionSheet)

        let addService = UIAlertAction(title: "Add Card", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            self.performSegue(withIdentifier: "AddCard", sender: nil)
            
        })
        
        let addGroup = UIAlertAction(title: "Add Group", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            self.performSegue(withIdentifier: "AddGroup", sender: nil)
            
        })

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        optionMenu.addAction(addService)
        optionMenu.addAction(addGroup)

        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)

    }

    func displayProfileMenu() {
        let optionMenu = UIAlertController(title: "Manage Profile", message: nil, preferredStyle: .actionSheet)


        let shareAction = UIAlertAction(title: "Share Profile", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            // set up activity view controller
            let stringToShare = [ ProfileModel.ProfileWebURL + (self.fullProfile?.info.username)! ]
            let activityViewController = UIActivityViewController(activityItems: stringToShare, applicationActivities: nil)
            
            // exclude some activity types from the list (optional)
            activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.addToReadingList, UIActivity.ActivityType.airDrop, UIActivity.ActivityType.assignToContact, UIActivity.ActivityType.openInIBooks, UIActivity.ActivityType.postToVimeo, UIActivity.ActivityType.saveToCameraRoll, UIActivity.ActivityType.print ]
            
            // present the view controller
            self.present(activityViewController, animated: true, completion: nil)
            
            
        })

        
        let editAction = UIAlertAction(title: "Edit Profile", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            self.performSegue(withIdentifier: "EditProfile", sender: self)
            
        })
        
        
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        
        optionMenu.addAction(shareAction)
        optionMenu.addAction(editAction)
        optionMenu.addAction(cancelAction)


        self.present(optionMenu, animated: true, completion: nil)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "EditCard", let elementCell = sender as? ProfileElementCell {
            
            let cell = segue.destination as! NewCardTableViewController
            
            cell.InitializeController(card: elementCell.element, groups: self.fullProfile?.cardGroups)
            
            
        } else if segue.identifier == "AddCard" {
            
            let cell = segue.destination as! NewCardTableViewController

            cell.InitializeController(groups: self.fullProfile?.cardGroups)
            
            
        } else if segue.identifier == "EditProfile" {
        
            let cell = segue.destination as! ProfileEditTableViewController
            
            cell.CustomInit(self.fullProfile!.info)
            
        } else if segue.identifier == "EditGroup", let infoCell = sender as? ExpandableHeaderView {
            
            let cell = segue.destination as! NewGroupTableViewController
            cell.groupToEdit = infoCell.group
            
        }
        
    }


}
