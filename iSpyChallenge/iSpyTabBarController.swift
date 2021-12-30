//
//  iSpyTabBarController.swift
//  iSpyChallenge
//

import UIKit
import CoreData

class iSpyTabBarController: UITabBarController {
    private let dataController = try! DataController(managedObjectModuleName: "iSpy",
                                                     persistentStoreType: NSSQLiteStoreType,
                                                     managedObjectModuleBundle: .main)
    
    private var photoController = try! PhotoController()
    
    // MARK: - View Controllers
    
    private var dataBrowserViewController: DataBrowserTableViewController? {
        viewControllers?
            .compactMap { ($0 as? UINavigationController)?.viewControllers.first as? DataBrowserTableViewController }
            .first
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataBrowserViewController?.photoController = photoController
        dataBrowserViewController?.users = dataController.users
    }
}
