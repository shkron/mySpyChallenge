//
//  NearMeViewController.swift
//  iSpyChallenge
//

import UIKit
import CoreData

class NearMeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    static let cellIdentifier = "ChallengeCell"
    
    var dataController: DataController?
    @IBOutlet weak var tableView: UITableView!
    private let coreDataManager = CoreDataManager.shared
    
    func fetchAllChallenges() {
        coreDataManager.fetchedResultsController.delegate = self
        do {
            try coreDataManager.fetchedResultsController.performFetch()
        } catch {
            print(error)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchAllChallenges()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(ChallengeTableViewCell.self, forCellReuseIdentifier: NearMeViewController.cellIdentifier)
        self.tableView.rowHeight  = UITableView.automaticDimension
        
        registerForDataControllerNotifications()
    }
    
    // MARK: - UITableViewDataSource & UITableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = coreDataManager.fetchedResultsController.sections else { return 0 }

        return sections[section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NearMeViewController.cellIdentifier, for: indexPath) as! ChallengeTableViewCell
        
        let challenge = coreDataManager.fetchedResultsController.object(at: indexPath)
        
        cell.challenge = challenge
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowChallenge", sender: self) // send CDChallenge
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: Updating UI
    
    private func registerForDataControllerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: .dataControllerDidUpdate, object: dataController)
    }
    
    @objc private func reloadData() {
        tableView.reloadData()
    }
}

extension NearMeViewController  : NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .none)
            }
            break
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .none)
            }
            break
        case .update:
        /* Updates are handled in insert and delete already
           When more granular updates are implemented
           This case will be used
            
            if let indexPath = indexPath,
                let cell = tableView.cellForRow(at: indexPath) as? ChallengeTableViewCell {
                cell.challenge = controller.object(at: indexPath) as? CDChallenge
             }
        */
            break
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
            break
        @unknown default:
            fatalError()
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}

extension NearMeViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChallenge", let challengeDetailViewController = segue.destination as? ChallengeDetailViewController {
            guard let selectedIndexPath = tableView.indexPathForSelectedRow else { return }
            let challenge = coreDataManager.fetchedResultsController.object(at: selectedIndexPath)
            challengeDetailViewController.challenge = challenge
        }
    }
}
