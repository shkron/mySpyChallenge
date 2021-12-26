//
//  RatingsTableViewController.swift
//  iSpyChallenge
//
//

import Foundation
import UIKit
import CoreData

class RatingsTableViewController: UITableViewController {
    var ratings: [Rating] = []
    
    // MARK: - UITableViewDataSource & UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ratings.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RatingCell", for: indexPath)
        
        if ratings.indices.contains(indexPath.row) {
            let rating = ratings[indexPath.row]
            cell.textLabel?.text = String(format: "%i", rating.stars)
            cell.detailTextLabel?.text = rating.player.username
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
