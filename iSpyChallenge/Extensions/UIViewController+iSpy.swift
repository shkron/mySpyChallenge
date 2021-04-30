//
//  UIViewController+iSpy.swift
//  iSpyChallenge
//

import UIKit

extension UIViewController {
    
    var contentViewController: UIViewController {
        if let navigationController = self as? UINavigationController, let vc = navigationController.topViewController {
            return vc
        } else {
            return self
        }
    }
}
