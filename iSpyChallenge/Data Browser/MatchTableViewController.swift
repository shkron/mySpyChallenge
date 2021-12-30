//
//  MatchTableViewController.swift
//  iSpyChallenge
//
//

import Foundation
import UIKit
import CoreData

enum MatchSectionType: String {
    case attributes
    case relationships
}

enum MatchRowType: String {
    case latitude
    case longitude
    case photoHref
    case verified
    case challenge
    case player
}

struct MatchRow {
    let type: MatchRowType
    let title: String?
    let detail: String?
}

struct MatchSection {
    let type: MatchSectionType
    let rows: [MatchRow]
}

struct MatchViewModel {
    let sections: [MatchSection]
    
    init(match: Match?) {
        let attributeSection = MatchSection(type: .attributes, rows: [
            MatchRow(type: .latitude, title: String(format: "%.5f", match!.latitude), detail: "latitude"),
            MatchRow(type: .longitude, title: String(format: "%.5f", match!.longitude), detail: "longitude"),
            MatchRow(type: .photoHref, title: match?.photoHref, detail: "photoHref"),
            MatchRow(type: .verified, title: match!.verified ? "True" : "False", detail: "verified")
        ])
        
        let relationshipSection = MatchSection(type: .relationships, rows: [
            MatchRow(type: .challenge, title: "Challenge", detail: nil),
            MatchRow(type: .player, title: "Player", detail: nil)
        ])
        
        self.sections = [attributeSection, relationshipSection]
    }
}

class MatchTableViewController: UITableViewController {
    var photoController: PhotoController!
    var match: Match?
    var viewModel: MatchViewModel?
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MatchViewModel(match: match)
    }

    // MARK: - UITableViewDataSource & UITableViewDelegate
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.sections.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.sections[safe: section]?.rows.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = viewModel?.sections[safe: indexPath.section]
        let row = section?.rows[safe: indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MatchCell")!
        cell.textLabel?.text = row?.title
        cell.detailTextLabel?.text = row?.detail
        
        if section?.type == .attributes {
            cell.accessoryType = .none
        }
        else {
            cell.accessoryType = .disclosureIndicator
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        viewModel?.sections[safe: section]?.type.rawValue
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = viewModel?
            .sections[safe: indexPath.section]?
            .rows[safe: indexPath.row]
        
        switch row?.type {
        case .challenge:
            performSegue(withIdentifier: "ShowChallenge", sender: self)
        case .player:
            performSegue(withIdentifier: "ShowPlayer", sender: self)
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        injectProperties(viewController: segue.destination)
    }
    
    // MARK: - Injection
    
    func injectProperties(viewController: UIViewController) {
        if let vc = viewController as? ChallengeTableViewController {
            vc.photoController = photoController
            vc.challenge = match?.challenge
        }
        
        if let vc = viewController as? UserTableViewController {
            vc.photoController = photoController
            vc.user = match?.player
        }
    }
}
