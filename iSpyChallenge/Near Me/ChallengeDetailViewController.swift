//
//  ChallengeDetailViewController.swift
//  iSpyChallenge
//

import UIKit

class ChallengeDetailViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    var challenge: CDChallenge?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let photoImageName = challenge?.photoImageName else { return }
        
        if let image = UIImage(named: photoImageName) {
            imageView.image = image
        } else {
            imageView.loadImageFromDiskWith(fileName: photoImageName)
        }
    }
}
