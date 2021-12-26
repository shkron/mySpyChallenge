//
//  MatchesTableViewController.swift
//  iSpyChallenge
//
//

import Foundation
import UIKit
import CoreData

class MatchesTableViewController: UITableViewController, PhotoControllerInjectable {
    var dataController: DataController!
    var photoController: PhotoController!
    var matches: [Match] = []
    
    // MARK: - UITableViewDataSource & UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        matches.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MatchCell", for: indexPath)
        
        if matches.indices.contains(indexPath.row) {
            let match = matches[indexPath.row]
            cell.textLabel?.text = "Match"
            cell.detailTextLabel?.text = String(format: "(%.5f, %.5f)", match.latitude, match.longitude)
            cell.imageView?.image = photoController.photo(withName: match.photoHref)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowMatch", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        injectProperties(viewController: segue.destination)
    }
    
    // MARK: - Injection
    
    func injectProperties(viewController: UIViewController) {
        if let vc = viewController as? PhotoControllerInjectable {
            vc.photoController = self.photoController
        }
        
        if let vc = viewController as? MatchInjectable,
           let row = tableView.indexPathForSelectedRow?.row,
           matches.indices.contains(row) {
            vc.match = matches[row]
        }
    }
}
