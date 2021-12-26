//
//  DataBrowserTableViewController.swift
//  iSpyChallenge
//

import UIKit
import CoreData

class DataBrowserTableViewController: UITableViewController {
    var photoController: PhotoController!
    var users: [User] = []
    
    // MARK: - UITableViewDataSource & UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
        
        if users.indices.contains(indexPath.row) {
            let user = users[indexPath.row]
            cell.textLabel?.text = user.username
            cell.detailTextLabel?.text = user.email
            
            if let thumbnailURL = URL(string: user.avatarThumbnailHref),
               let data = (try? Data(contentsOf: thumbnailURL)) ?? nil {
                cell.imageView?.image = UIImage(data: data)
            } else {
                cell.imageView?.image = nil
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowUser", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
        
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        injectProperties(viewController: segue.destination)
    }
    
    // MARK: - Injection
    
    func injectProperties(viewController: UIViewController) {
        if let vc = viewController as? UserTableViewController {
            vc.photoController = photoController
            
            if let row = tableView.indexPathForSelectedRow?.row,
               users.indices.contains(row) {
                vc.user = users[row]
            }
        }
    }
}
