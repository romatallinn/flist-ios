//
//  CardTemplateTableViewController.swift
//  Flist
//
//  Created by Роман Широков on 31.03.18.
//  Copyright © 2018 Flist. All rights reserved.
//

import UIKit

class CardTemplateTableViewController: UITableViewController, UISearchBarDelegate {

    let cellIdentifier = "TemplatePickerCell"
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var isSearching: Bool = false
    var filteredList = [ServiceListElement]()
    var selectedCell: CardTemplateTableViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        searchBar.barTintColor = UIColor.mainColorTheme
        
        self.tableView.tableFooterView = UIView()
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int { return 1 }
    
    // Count of all available templates (currently in ProfileModel.services) or filtered data of search
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ( isSearching ) ? filteredList.count : ServiceModel.services.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CardTemplateTableViewCell
        
        let row = indexPath.row
        var service: ServiceListElement
        
        if isSearching { service = filteredList[row] }
        else { service = ServiceModel.services[row] }
        
        cell.InitializeCell(tmpType: service.shortcut)

        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! CardTemplateTableViewCell
        selectedCell = cell
        
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "ShowServiceInfoSegue", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowServiceInfoSegue" {
            
            let cell = segue.destination as! CardServiceTemplateTableViewController
            cell.InitializeTemplate(type: selectedCell?.tmpType)
            
        }
    }
    
    
    // MARK: Search Bar Functions
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard !searchText.isEmpty else {
            filteredList.removeAll()
            isSearching = false
            tableView.reloadData()
            return
        }
        
        isSearching = true
        
        filteredList = ServiceModel.services.filter({
            service -> Bool in
            service.name.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) { searchBar.resignFirstResponder() }
    

}
