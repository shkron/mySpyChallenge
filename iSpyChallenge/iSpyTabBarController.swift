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

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        dataController = try! DataController.init(managedObjectModuleName: "iSpy", persistentStoreType: NSSQLiteStoreType, managedObjectModuleBundle: .main)
    }
}
