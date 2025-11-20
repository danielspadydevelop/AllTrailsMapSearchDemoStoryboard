//
//  ResturauntListViewController+UISearchBarDelegate.swift
//  AllTrailsMapSearchDemoStoryboard
//
//  Created by Daniel Spady on 11/19/25.
//

import UIKit

extension ResturauntListViewController: UISearchBarDelegate {    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchText = searchBar.text else { return }

        if searchText.isEmpty {
            filteredItems = resturauntList
        } else {
            filteredItems = resturauntList.filter { $0.cellHeader.lowercased().contains(searchText.lowercased()) }
        }
        tableView.reloadData()
    }
}
