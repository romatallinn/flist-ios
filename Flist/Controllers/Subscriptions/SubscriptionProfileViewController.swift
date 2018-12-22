//
//  MyProfileViewController.swift
//  Together
//
//  Created by Роман Широков on 13.06.17.
//  Copyright © 2017 Roman Sirokov. All rights reserved.
//

import UIKit
import FirebaseAnalytics

class SubscriptionProfileViewController: ProfileViewController, ProfileViewProtocol, UITableViewDataSource, UITableViewDelegate, ExpandableHeaderViewDelegate {
    

    @IBOutlet weak var tableView: UITableView!
    
    public var dynamicUsername: String? {
        didSet { isDynamicLink = true }
    }
    var isDynamicLink: Bool = false
    
    var id: String = "0"
    var isFollowing: Bool = false

    let authModel = AuthModel()

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
                
        isOwned = false
        
        tableView.delegate = self
        tableView.dataSource = self
        

        refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.mainColorTheme
        tableView.addSubview(refreshControl)
        
//        if isDynamicLink {
//            self.navigationItem.rightBarButtonItem?.isEnabled = false
//            self.navigationItem.backBarButtonItem?.isEnabled = false
//        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        TableViewLoadData()
    }
    
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if refreshControl.isRefreshing && !isUpdating {
            
            TableViewLoadData()
            
        }
        
    }
    
    func TableViewLoadData() {
        
//        refreshControl.beginRefreshing()
        isUpdating = true
        fullProfile = nil
        
        if !isDynamicLink {
        
            model.getFullProfileWith (userID: id) {
                
                (_, info, groups, cards) in
                
                DispatchQueue.main.async {
                 
                    self.DataFetchAndDisplay(info: info, groups: groups, cards: cards)
                    
                }
                
            }
            
        } else {
            
            model.getFullProfileWith (username: dynamicUsername!) {
                
                (uid, info, groups, cards) in
                
                DispatchQueue.main.async {
                    
                    self.id = uid!
                    self.DataFetchAndDisplay(info: info, groups: groups, cards: cards)
                    
                }
                
            }
            
        }
        
    }
    
    func DataFetchAndDisplay(info: NSDictionary?, groups: NSDictionary?, cards: NSDictionary?){
        
        let profInfo = ProfileInfoElement(info!)
        
        self.authModel.getUserProfileImage(uid: self.id, completionHandler: {
            (img) in
            
            guard let img = img else { return }
            
            self.fullProfile?.info.img = img
            
            self.tableView.reloadRows(at: [IndexPath.init(row: 0, section: 0)], with: UITableView.RowAnimation.automatic)
            
        })
        
        
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
                
                if let i = sections.index(where: { $0.id == group_id }) {
                    
                    sections[i].cards.append(CardElement(valArr, id: key as? String))
                    
                    
                } else {
                    
                    if initGroup == nil {
                        
                        initGroup = ["name" : " ", "id": "0"]
                        sections.insert(CardGroup(initGroup!), at: 0)
                        
                    }
                    
                    sections[0].cards.append(CardElement(valArr, id: key as? String))
                    
                }
                
                
            }
            
        }
        
        
        self.fullProfile = ProfileFull(info: profInfo, cardGroups: sections)
        self.tableView.reloadData()
        self.refreshControl.endRefreshing()
        self.isUpdating = false
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(indexPath.section == 0) {
            if indexPath.row == 0 {
                let cell = Bundle.main.loadNibNamed(profileInfoNib, owner: self, options: nil)?.first as! ProfileInfoCell
               
                if let info = fullProfile?.info {
                    cell.CustomInit(info, isOwned: false, viewController: self)
                }else {
                    cell.CustomInit(nil, isOwned: false, viewController: self)
                }
                
                return cell
            } else if fullProfile?.cardGroups.count == 0 {
                let cell = Bundle.main.loadNibNamed(emptyPlaceholderNib, owner: self, options: nil)?.first as! UITableViewCell
            
                return cell
            }
        }
        
        let cell = Bundle.main.loadNibNamed(profileListNib, owner: self, options: nil)?.first as! ProfileElementCell
        
        let row = indexPath.row
        let sec = indexPath.section - 1
        
        if let element = (fullProfile?.cardGroups[sec].cards[row]) {
        
            cell.CustomInit(element, isOwned: false, viewController: self)
        
        } else {
            cell.CustomInit(nil, isOwned: false, viewController: self)
        }
        
        return cell
    }
    
    func toggleSection(header: ExpandableHeaderView, section: Int) {
        
        
        let newState = !((fullProfile?.cardGroups[section-1].expanded)!)
        fullProfile?.cardGroups[section-1].expanded = newState
        
        tableView.beginUpdates()
        
        for i in 0 ..< (fullProfile?.cardGroups[section-1].cards.count)! {
            tableView.reloadRows(at: [IndexPath(row: i, section: section)], with: .automatic)
        }
        
        tableView.endUpdates()
        
    }
    
    
    
    @IBAction func EditFriend(_ sender: Any) {
        
        // 1
        let optionMenu = UIAlertController(title: "Choose Action", message: nil, preferredStyle: .actionSheet)
        
        // 2
//        let blockAction = UIAlertAction(title: "Block", style: .destructive, handler: {
//            (alert: UIAlertAction!) -> Void in
//
//            self.ShowAlert(msg: "Are you sure?", completion: nil)
//
//        })
        
//        let reportAction = UIAlertAction(title: "Report", style: .destructive, handler: {
//            (alert: UIAlertAction!) -> Void in
//
//            self.ShowAlert(msg: "Are you sure that you want to report this user?", completion: nil)
//
//        })
//
//        let sendMsgAction = UIAlertAction(title: "Send Message", style: .default, handler: {
//            (alert: UIAlertAction!) -> Void in
//
//        })

        var subActionTitle: String
        var style: UIAlertAction.Style
        
        if isFollowing {
            
            subActionTitle = "Unfollow"
            style = .destructive
            
        } else {
            
            subActionTitle = "Follow"
            style = .default
            
        }
        

        let subscriptionAction = UIAlertAction(title: subActionTitle, style: style, handler: {
            (alert: UIAlertAction!) -> Void in
            
            if self.isFollowing {
                self.Unfollow()
            } else {
                self.Follow()
            }
            

        })
            
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in

        })
        

        // 4
//        optionMenu.addAction(sendMsgAction)
        optionMenu.addAction(subscriptionAction)
//        optionMenu.addAction(blockAction)
//        optionMenu.addAction(reportAction)

        optionMenu.addAction(cancelAction)
        
        // 5
        self.present(optionMenu, animated: true, completion: nil)
        
    }
    
    func Follow() {
        
        self.ShowChoiceAlert(title: "Follow", msg: "Are you sure that you want to add this user to the subscription list?") {

            (alert) in

            let contModel = SubscrtiptionFollowingModel()

            contModel.FollowUserWithUsername((self.fullProfile?.info.username)!, completionHandler: {
                (error) in
                
                if let err = error {
                    
                    self.ShowAlert(msg: err)
                    
                } else {
                    
                    DispatchQueue.main.async {
                        self.isFollowing = !self.isFollowing
                        self.UpdateTableInRoot()
                        self.ShowAlert(title: "Followed", msg: "The user is now followed!")
                    }
                    
                }
                
            })
        }

    }
    
    func Unfollow() {
        
        self.ShowChoiceAlert(title: "Unfollow", msg: "Are you sure that you want to delete this user from the subscription list?") {
            
            (alert) in
            
            let contModel = SubscrtiptionFollowingModel()
            
            
            contModel.UnfollowUserWithId(self.id) {
                
                (success) in
                
                
                DispatchQueue.main.async {
                    
                    if success {
                        
                        self.isFollowing = !self.isFollowing
                        self.UpdateTableInRoot()
                        
                        // Firebase Analytics -- Unfollow User event
                        Analytics.logEvent("user_unfollowed", parameters: [
                            "username_unfollowed": (self.fullProfile?.info.username)!
                            ])
                        
                        self.ShowAlert(title: "Unfollowed", msg: "The user is now unfollowed!")
                        
                    }
                }
                
            }
            
        }
        
    }
    
    func UpdateTableInRoot() {
        if let viewControllers = self.navigationController?.viewControllers {
            
            let count = viewControllers.count
            
            if count > 1 {
                if let vc = viewControllers[count - 2] as? SubscriptionsViewController {
                    vc.TableViewLoadData(1)
                }
            }
            
        }
    }
    
    
    func ShowChoiceAlert(title: String, msg: String, completion: ((UIAlertAction) -> (Void))?) {
    
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: completion))
        
        self.present(alert, animated: true, completion: nil)
    
    }
}
