//
//  iSpyTabBarController.swift
//  iSpyChallenge
//

import UIKit
import CoreData

class iSpyTabBarController: UITabBarController {
    private let dataController = DataController(apiService: APIService())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nearMeViewController?.dataController = dataController
        newChallengeViewController?.dataController = dataController
        dataBrowserViewController?.dataController = dataController
        
        dataController.loadAllData()
    }
}

private extension iSpyTabBarController {
    var nearMeViewController: NearMeViewController? {
        viewControllers?
            .compactMap { ($0 as? UINavigationController)?.viewControllers.first as? NearMeViewController }
            .first
    }
    
    var newChallengeViewController: NewChallengeViewController? {
        viewControllers?
            .compactMap { ($0 as? UINavigationController)?.viewControllers.first as? NewChallengeViewController }
            .first
    }
    
    var dataBrowserViewController: DataBrowserTableViewController? {
        viewControllers?
            .compactMap { ($0 as? UINavigationController)?.viewControllers.first as? DataBrowserTableViewController }
            .first
    }
}
