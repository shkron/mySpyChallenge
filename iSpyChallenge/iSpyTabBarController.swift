//
//  iSpyTabBarController.swift
//  iSpyChallenge
//

import UIKit
import CoreData

class iSpyTabBarController: UITabBarController {
    private var dataController: DataController! {
        didSet {
            if let viewControllers = viewControllers {
                for vc in viewControllers where vc.contentViewController is DataControllerInjectable {
                    (vc.contentViewController as! DataControllerInjectable).dataController = dataController
                }
            }
        }
    }
    
    private var photoController: PhotoController! {
        didSet {
            if let viewControllers = viewControllers {
                for vc in viewControllers where vc.contentViewController is PhotoControllerInjectable {
                    (vc.contentViewController as! PhotoControllerInjectable).photoController = photoController
                }
            }
        }
    }
    
    // MARK: - View Controllers
    
    private var dataBrowserViewController: DataBrowserTableViewController? {
        viewControllers?
            .compactMap { ($0 as? UINavigationController)?.viewControllers.first as? DataBrowserTableViewController }
            .first
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataController = try! DataController.init(managedObjectModuleName: "iSpy", persistentStoreType: NSSQLiteStoreType, managedObjectModuleBundle: .main)
        
        photoController = try! PhotoController()
        
        dataBrowserViewController?.users = dataController.users
    }
}
