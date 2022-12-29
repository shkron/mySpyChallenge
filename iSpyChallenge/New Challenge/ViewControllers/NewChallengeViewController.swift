//
//  NewChallengeViewController.swift
//  iSpyChallenge
//

import UIKit

class NewChallengeViewController: UIViewController {
    
    var dataController: DataController?
    
    // MARK: - Outlets
    
    @IBOutlet weak var takePhotoButton: UIButton!
    @IBOutlet weak var separatorLabel: UILabel!
    @IBOutlet weak var choosePhotoButton: UIButton!
    
    // MARK: - Actions
    
    @IBAction func takePhotoButtonTapped(_ sender: UIButton) {
        presentCameraImagePicker()
    }
    
    @IBAction func choosePhotoButtonTapped(_ sender: UIButton) {
        presentLibraryImagePicker()
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Image Pickers
    private func presentCameraImagePicker() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .camera
            imagePicker.delegate = self
            present(imagePicker, animated: true)
        } else {
            let alertController = UIAlertController(title: nil, message: "Device has no camera.", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { (alert: UIAlertAction!) in
            })
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    private func presentLibraryImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
}

// MARK: - UIImagePickerControllerDelegate
extension NewChallengeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Check if an image was selected
            if let selectedImage = info[.originalImage] as? UIImage {
                // Perform the segue to the detail view controller
                performSegue(withIdentifier: "CreateNewChallenge", sender: selectedImage)
            }
            
            dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}

extension NewChallengeViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CreateNewChallenge", let createNewChallengeViewController = segue.destination as? CreateNewChallengeViewController, let selectedImage = sender as? UIImage {
            
            let newChallengeModel = CreateNewChallengeModel(dataController: dataController, image: selectedImage)
            
            createNewChallengeViewController.newChallengeModel = newChallengeModel
        }
    }
}
