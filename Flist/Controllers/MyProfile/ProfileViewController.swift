//
//  ProfileViewController.swift
//  Flist
//
//  Created by Роман Широков on 05.11.17.
//  Copyright © 2017 Flist. All rights reserved.
//

import UIKit

protocol ProfileViewProtocol {
    var tableView: UITableView! { get set }
    func TableViewLoadData()
}

class ProfileViewController: UIViewController {

    // Names of Nibs (storyboards)
    @IBInspectable var profileInfoNib: String = "ProfileInfoElement"
    @IBInspectable var profileListNib: String = "CardElement"
    @IBInspectable var emptyPlaceholderNib: String = "EmptyDataPlaceholderTableView"

    // Profile
    var fullProfile: ProfileFull? = nil
    
    // Is this profile owned by user?
    var isOwned: Bool!
    
    // Init profile model
    let model = ProfileModel()
    
    // Is data currently updating?
    var isUpdating: Bool = false
    
    // Refreshing control
    var refreshControl : UIRefreshControl!

    
    @objc(tableView:heightForRowAtIndexPath:) func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        // Profile cell is always opened
        // If no profile yet loaded, open all groups for skeleton
        if (indexPath.row == 0 && indexPath.section == 0 || fullProfile == nil) {
            return 130
        }
        
        let profile = fullProfile!
        
        // If there are no groups or cards, open row for the empty data placeholder.
        // For other cases, check if the group is opened.
        if (profile.cardGroups.count == 0 || profile.cardGroups[indexPath.section-1].expanded) {
            return 120
        }
        else {
            return 0
        }
    }
    
    @objc func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        // No headers in section 0 (profile cell)
        if section == 0 {
            return 0
        }
        
        // All other rows do have header (group name)
        return 44
    }
    
    // All rows have some footer spacing
    @objc func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    @objc(numberOfSectionsInTableView:) func numberOfSections(in tableView: UITableView) -> Int {
        
        // If no profile loaded, there is 1 section only (loading skeleton of profile and a few cards)
        if(fullProfile == nil) {
            return 1
        }
        
        // Otherwise, there are amount of groups + profile section
        return (fullProfile?.cardGroups.count)! + 1
    }
    
    @objc func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // If no profile yet loaded, there is 1 section (defined above) with 5 rows in it.
        if (fullProfile == nil) {
            return 5
        }
        
        if(section == 0) {
            // First section, 2 rows if no groups (profile cell + empty data placeholder)
            // Otherwise, only profile cell
            return (fullProfile?.cardGroups.count == 0) ? 2 : 1
        } else {
            // For all other sections, see how many cards the group has
            return (fullProfile?.cardGroups[section-1].cards.count)!
        }
    }

    
    @objc func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
        // No header for first section (profile cell)
        // No header if profile is not yet loaded (skeleton views aren't grouped)
        if section == 0 || fullProfile == nil {
            return nil
        }
        
        let profile = fullProfile!
        
        // Header == group label
        // Initialize the group label & its content
        let header = ExpandableHeaderView()
        header.isOwned = isOwned
        header.customInit(title: profile.cardGroups[section-1].name, group: profile.cardGroups[section-1], section: section, delegate: self as! ExpandableHeaderViewDelegate, viewController: self)
        
        
        return header
    
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        // White out underlaying lines
        let footer = UIView()
        return footer
        
    }
    
    
    @objc(tableView:didSelectRowAtIndexPath:) func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // No funcionality if first section selected (profile cell)
        // No func. if there are no profile yet loaded
        if(indexPath.section == 0 || fullProfile == nil) {
            return
        }
        
        // Otherwise, see what element is at row
        let cell = tableView.cellForRow(at: indexPath) as! ProfileElementCell
        
        // Create url and open if possible
        if let url = URL(string: cell.url) {
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
            
        }
    }
    

}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
