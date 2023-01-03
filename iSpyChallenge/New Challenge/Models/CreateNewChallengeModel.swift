//
//  CreateNewChallengeModel.swift
//  iSpyChallenge
//

import UIKit

struct CreateNewChallengeModel {
    let dataController: DataController?
    let image: UIImage?
    var hint: String? // hint can be updated during editing
    
    init(dataController: DataController?, image: UIImage?) {
        self.dataController = dataController
        self.image = image
    }
}
