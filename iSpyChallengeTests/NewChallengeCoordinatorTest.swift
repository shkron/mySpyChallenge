//
//  NewChallengeCoordinatorTest.swift
//  iSpyChallenge
//

import XCTest

final class NewChallengeCoordinatorTest: XCTestCase {
    
    private var newChallengeModel: CreateNewChallengeModel!
    private var image: UIImage!
    private var dataController: DataController!
    private var newChallengeCoordinator: NewChallengeCoordinator!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        dataController = DataController(apiService: APIService())
        image = try loadImage(named: "alcatraz-island", type: "jpg")
        newChallengeModel = CreateNewChallengeModel(dataController: dataController, image: image)
        newChallengeCoordinator = NewChallengeCoordinator(newChallengeModel: newChallengeModel)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        dataController = nil
        image = nil
        newChallengeModel = nil
        newChallengeCoordinator = nil
    }
    
    func loadImage(named name: String, type:String = "png") throws -> UIImage {
        let bundle = Bundle.main
        guard let path = bundle.path(forResource: name, ofType: type) else {
            throw NSError(domain: "loadImage", code: 1, userInfo: nil)
        }
        guard let image = UIImage(contentsOfFile: path) else {
            throw NSError(domain: "loadImage", code: 2, userInfo: nil)
        }
        return image
    }

    func testFileNameFromDate() {
        let newChallengeCoordinator = NewChallengeCoordinator(newChallengeModel: nil)
        let date = Date()
        let fileName = newChallengeCoordinator.fileName(from: date)
        XCTAssertTrue(fileName.count > 4)
    }
    
    func testFileNamesNotEqualFromDates() {
        let newChallengeCoordinator = NewChallengeCoordinator(newChallengeModel: nil)
        let date1 = Date()
        let fileName1 = newChallengeCoordinator.fileName(from: date1)
        let date2 = Date()
        let fileName2 = newChallengeCoordinator.fileName(from: date2)
        XCTAssertNotEqual(fileName2, fileName2)
    }
    
    func testNewChallengeSubmissionFailsWithoutModel() {
        let newChallengeCoordinator = NewChallengeCoordinator(newChallengeModel: nil)
        
        var successAssert = false
        newChallengeCoordinator.submitChallenge { success in
            successAssert = success
        }
        
        waitForExpectations(timeout: 3) { (error) in
            XCTAssertFalse(successAssert)
        }

    }
    
    func testSaveToDocuments() {
        guard let imageData = image.jpegData(compressionQuality: 1.0) else { print("No image data"); return }
        
        XCTAssertTrue(newChallengeCoordinator.saveToDocuments(imageData: imageData))
    }
    
    func testNewChallengeSubmissionSucceedsWithModel() throws {
        var successAssert = false
        newChallengeCoordinator.submitChallenge { success in
            successAssert = success
        }
        
        waitForExpectations(timeout: 3) { (error) in
            XCTAssertTrue(successAssert)
        }

    }
}
