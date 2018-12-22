//
//  ContactsViewController.swift
//  Together
//
//  Created by Роман Широков on 06.07.17.
//  Copyright © 2017 Roman Sirokov. All rights reserved.
//

import UIKit

class SubscriptionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var subStateSegmentedControl: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    let textCellIdentifier = "ContactElement"
    
    var subscriptionsList = [ [SubscriptionUserListElement](), [SubscriptionUserListElement]() ]
    
    var filteredList = [SubscriptionUserListElement]()
    
    let model = [
        SubscrtiptionFollowersModel(),
        SubscrtiptionFollowingModel()
    ]
    
    let authModel = AuthModel()

    var isUpdating: Bool = false
    var isSearching: Bool = false
    
    var refreshControl : UIRefreshControl!
    
    // Data for User Profile view
    var chosenId : String = "0"
    var isChosenFollowing: Bool = false
    
    var curStateIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        searchBar.delegate = self
        
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.mainColorTheme
        tableView.addSubview(refreshControl)
        
        searchBar.barTintColor = UIColor.mainColorTheme
        subStateSegmentedControl.tintColor = UIColor.mainColorTheme
        
        curStateIndex = subStateSegmentedControl.selectedSegmentIndex

        
        TableViewLoadData(0)
        TableViewLoadData(1)
        
    }

    @IBAction func subStateSegmentedAction(_ sender: Any) {
        curStateIndex = subStateSegmentedControl.selectedSegmentIndex
        tableView.reloadData()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if refreshControl.isRefreshing && !isUpdating{
            TableViewLoadData(curStateIndex)
        }
    }
    
    func TableViewLoadData(_ index: Int) {
        
        refreshControl.beginRefreshing()
        isUpdating = true
        
        self.subscriptionsList[index].removeAll()
        
        
        model[index].GetSubscriptionData() {
            (subscriptionList) in
            
            DispatchQueue.main.async {
                
                for value in subscriptionList {
                    
                    let val = value as! [String: Any]
                    
                    let el = SubscriptionUserListElement(val)
                    self.subscriptionsList[index].append(el)
                    
                    let ind = self.subscriptionsList[index].count-1
                    
                    self.authModel.getUserProfileImage(uid: el.id, completionHandler: {
                        (img) in
                        
                        guard let img = img else { return }
                        
                        self.subscriptionsList[index][ind].avatar = img
                        
                        if index == self.curStateIndex {
                            self.tableView.reloadRows(at: [IndexPath.init(row: ind, section: 0)], with: UITableView.RowAnimation.automatic)
                        }
                        
                    })

                    
                }
                
                var lbl: String
                let count: Int = self.subscriptionsList[index].count
                
                // Change titles of segmented controller relatively to amount of followers/following
                if index == 0 { lbl = (count == 1) ? " Follower" : " Followers" }
                else { lbl = " Following" }
                
                self.subStateSegmentedControl.setTitle( count.description + lbl, forSegmentAt: index )

                if index == self.curStateIndex { self.tableView.reloadData() }
                
                self.refreshControl.endRefreshing()
                self.isUpdating = false
                        
            }

        }
    
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int { return 1 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredList.count : subscriptionsList[self.curStateIndex].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath) as! SubscriptionsTableViewCell
        
        let row = indexPath.row
        
        var listToPresent: [SubscriptionUserListElement]
        
        if isSearching {
            listToPresent = filteredList
        } else {
            listToPresent = subscriptionsList[curStateIndex]
        }
        
        
        cell.id = listToPresent[row].id
        cell.avatar.roundView()
        cell.avatar.image = listToPresent[row].avatar
        cell.name.text = listToPresent[row].fullName
        cell.username.text = listToPresent[row].username
        cell.verifiedImg.isHidden = !listToPresent[row].verified
        cell.date = listToPresent[row].date
        
        print("Date get: " + cell.date)
        let interval = NSDate.IntervalSince(cell.date)        
        cell.newBadge.isHidden = (curStateIndex == 1 || interval >= 24) ? true : false
            
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! SubscriptionsTableViewCell
        
        chosenId = cell.id
        
        isChosenFollowing = subscriptionsList[1].filter({
            user -> Bool in
            user.id.contains(chosenId)
        }).count > 0 ? true : false
        
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "SubscriptionsToUserProfile", sender: nil)

    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SubscriptionsToUserProfile" {
        
            let cell = segue.destination as! SubscriptionProfileViewController
            
            cell.id = chosenId
            cell.isFollowing = isChosenFollowing
            
            chosenId = "0"
            isChosenFollowing = false

        
        }
    }

    @IBAction func FindAnotherUser(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Find Another User", message: "Please input username:", preferredStyle: .alert)
        
        
        let confirmAction = UIAlertAction(title: "Search", style: .default) { (_) in
            if let field = alertController.textFields?[0] {

                self.model[0].GetIdForUsername(username: field.text!, completionHandler: {
                    (snap_id) in
                    
                    if let id = snap_id {
                        self.chosenId = id
                        self.performSegue(withIdentifier: "SubscriptionsToUserProfile", sender: nil)
                    } else {
                        
                        self.ShowNoUserAlert()
                        
                    }
                        
                })
                
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Username"
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func ShowNoUserAlert() {
        
        let alert = UIAlertController(title: "Error", message: "There is no user with such username!", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Try again", style: UIAlertAction.Style.default, handler: {
            (action) in
            self.FindAnotherUser(self)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    // MARK: Search Bar Functions
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard !searchText.isEmpty else {
            filteredList = [SubscriptionUserListElement]()
            isSearching = false
            tableView.reloadData()
            return
        }
        
        isSearching = true
        
        filteredList = subscriptionsList[curStateIndex].filter({
            user -> Bool in
            user.fullName.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) { searchBar.resignFirstResponder() }
    
}
