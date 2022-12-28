//
//  NearMeViewController.swift
//  iSpyChallenge
//
//

import UIKit

class NearMeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var dataController: DataController?
    @IBOutlet weak var tableView: UITableView!
    
    private var challenges: [Challenge] = []
    private let placeholder = UIImage(named: "placeholder")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        updateUI()
        registerForDataControllerNotifications()
    }
    
    // MARK: - UITableViewDataSource & UITableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        challenges.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChallengeCell", for: indexPath)
        
        if let challenge = challenges[safe: indexPath.row] {
            cell.textLabel?.text = challenge.id
            cell.detailTextLabel?.text = challenge.hint
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowChallenge", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: Updating UI
    
    private func registerForDataControllerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: .dataControllerDidUpdate, object: dataController)
    }
    
    @objc private func updateUI() {
        challenges = dataController?.allChallenges ?? []
        tableView.reloadData()
    }
}

