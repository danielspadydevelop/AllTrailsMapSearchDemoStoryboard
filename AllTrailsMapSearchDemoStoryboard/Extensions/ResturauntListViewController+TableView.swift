//
//  ResturauntListViewController+TableView.swift
//  AllTrailsMapSearchDemoStoryboard
//
//  Created by Daniel Spady on 11/19/25.
//

import UIKit

extension ResturauntListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return
    }
}

extension ResturauntListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredItems.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.layer.masksToBounds = true
        let radius = cell.contentView.layer.cornerRadius
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: radius).cgPath
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ResturauntTableCell", for: indexPath) as? ResturauntTableCellView else {
            fatalError("Unable to dequeue MyCustomCell")
        }
        
        let viewModel = filteredItems[indexPath.row]
        cell.updateCell(with: viewModel)
        
        return cell
    }
}
