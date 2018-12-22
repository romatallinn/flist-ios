//
//  SearchBarResignable.swift
//  Flist
//
//  Created by Роман Широков on 26.03.18.
//  Copyright © 2018 Flist. All rights reserved.
//

import UIKit

// Search Bar resignable on return key
class SearchBarReturnResignable: UISearchBar, UISearchBarDelegate {

    override init(frame: CGRect) {
        super.init(frame:frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.delegate = self
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}
