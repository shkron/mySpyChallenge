//
//  NewChallengeCoordinator.swift
//  iSpyChallenge
//

import Foundation

class NewChallengeCoordinator {
    
    private let coreDataManager: CoreDataManager
    private let newChallengeModel: CreateNewChallengeModel?
    
    private lazy var apiLocation: APILocation = {
        let coordinate = LocationManager.shared.currentLocation?.coordinate ?? LocationManager.mockedLocation.coordinate
        return APILocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }()
    
    private lazy var fileName: String = {
        return fileName(from: Date())
    }()
    
    init(coreDataManager: CoreDataManager = .shared, newChallengeModel: CreateNewChallengeModel?) {
        self.coreDataManager = coreDataManager
        self.newChallengeModel = newChallengeModel
    }
    
    func fileName(from date: Date) -> String {
        let formater = DateFormatter()
        formater.dateStyle = .long
        formater.timeStyle = .long
        guard let dateName = formater.string(from: date).removingPercentEncoding else { return "" }
        let fileName = dateName.replacingOccurrences(of: " ", with: "_") + ".jpg"
        return fileName
    }
    
    func submitChallenge(completion: @escaping (Bool) -> Void) {
        guard let newChallengeModel = newChallengeModel else { print("Model is empty"); return }
        guard let imageData = newChallengeModel.image?.jpegData(compressionQuality: 1.0) else { print("No image data"); return }
        guard let hint = newChallengeModel.hint else { print("No hint text"); return }
        
        if saveToDocuments(imageData: imageData) {
            let challenges = coreDataManager.allChallenges()
            guard let lastID = challenges.compactMap({ Int($0.id ?? "0") ?? 0 }).max() else { return }
            print(lastID)
            
            guard var currentUser = newChallengeModel.dataController?.currentUser else { print("No current user info"); return }
            
            let challange = Challenge(id: "\(lastID + 1)",
                                      hint: hint,
                                      latitude: apiLocation.latitude,
                                      longitude: apiLocation.longitude,
                                      photoImageName: fileName,
                                      creatorID: currentUser.id)
                    
            currentUser.challenges.append(challange)
            _ = coreDataManager.insert(user: currentUser)
            
            // API Submission
            
            newChallengeModel.dataController?
            .createChallengeForCurrentUser(
                hint: hint,
                latitude: apiLocation.latitude,
                longitude: apiLocation.longitude,
                photoImageName: fileName,
                completion: completion
            )
        }
    }
    
    func saveToDocuments(imageData: Data) -> Bool {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return false }
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                // Remove older image with the same name
                try FileManager.default.removeItem(atPath: fileURL.path)
            } catch let removeError {
                print("Couldn't remove file at path: ", fileURL.path, removeError)
            }
        }
        
        do {
            try imageData.write(to: fileURL)
            return true
        } catch let error {
            print("Error saving file with error: ", error)
            return false
        }
    }
}
