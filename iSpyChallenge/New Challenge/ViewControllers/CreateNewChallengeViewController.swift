//
//  CreateNewChallengeViewController.swift
//  iSpyChallenge
//


import UIKit

class CreateNewChallengeViewController: UIViewController {

    var newChallengeModel: CreateNewChallengeModel?
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var hintLabel: UILabel!
    @IBOutlet weak var hintTextField: UITextField!
    @IBOutlet private weak var submitButton: UIButton!
    @IBOutlet private weak var loadingSpinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let image = newChallengeModel?.image else {
            print("No image")
            navigationController?.popToRootViewController(animated: true)
            return
        }
        
        imageView.image = image
        hintTextField.delegate = self
        
        subscribeToKeyboardNotifictions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadingSpinner.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        unSubscribeToKeyboardNotifictions()
    }
    
    // MARK: - IBActions
    
    @IBAction func didTapSubmit(_ sender: Any) {
        hintTextField.resignFirstResponder()
        loadingSpinner.startAnimating()
        loadingSpinner.isHidden = false

        guard let inputText = hintTextField.text, !inputText.isEmpty else {
            loadingSpinner.isHidden = true
            let alert = UIAlertController(title: "Hint cannot be empty", message: "Please add a hint to your challenge", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true, completion: nil)
            return
        }
        
        newChallengeModel?.hint = hintTextField.text
        let newChallengeCoordinator = NewChallengeCoordinator(newChallengeModel: newChallengeModel)
        newChallengeCoordinator.submitChallenge { _ in
            print("GREAT SUCCESS!!")
        }
        self.navigationController?.popToRootViewController(animated: true)
        self.tabBarController?.selectedIndex = 0
    }
}

// MARK: - UITextFieldDelegate

extension CreateNewChallengeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

// MARK: - Keyboard notifications

extension CreateNewChallengeViewController {
    
    func subscribeToKeyboardNotifictions() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unSubscribeToKeyboardNotifictions() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.size.height == UIScreen.main.bounds.height {
                UIView.animate(withDuration: 0.1, animations: {
                    self.view.frame.size.height -= keyboardSize.height
                })
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.size.height != UIScreen.main.bounds.height {
            UIView.animate(withDuration: 0.1, animations: {
                self.view.frame.size.height = UIScreen.main.bounds.height
            })
        }
    }
}
