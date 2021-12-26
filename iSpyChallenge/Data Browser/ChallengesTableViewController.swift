//
//  ChallengesTableViewController.swift
//  iSpyChallenge
//
//

import UIKit
import CoreData

class ChallengesTableViewController: UITableViewController, PhotoControllerInjectable {
    var photoController: PhotoController!
    var challenges: [Challenge] = []
    
    // MARK: - UITableViewDataSource & UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        challenges.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChallengeCell", for: indexPath)
        
        if challenges.indices.contains(indexPath.row) {
            let challenge = challenges[indexPath.row]
            cell.textLabel?.text = challenge.hint
            cell.detailTextLabel?.text = String(format: "(%.5f, %.5f)", challenge.latitude, challenge.longitude)
            cell.imageView?.image = photoController.photo(withName: challenge.photoHref)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowChallenge", sender: self)
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
        
        if let vc = viewController as? ChallengeTableViewController,
           let row = tableView.indexPathForSelectedRow?.row,
           challenges.indices.contains(row) {
            vc.challenge = challenges[row]
        }
    }

}
