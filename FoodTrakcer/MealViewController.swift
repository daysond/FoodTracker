//
//  MealViewController.swift
//  FoodTrakcer
//
//  Created by Dayson Dong on 2019-06-08.
//  Copyright © 2019 Dayson Dong. All rights reserved.
//

import UIKit
import os.log

class MealViewController: UIViewController {
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    
    var meal: Meal?
    override func viewDidLoad() {
        super.viewDidLoad()
        updateSaveButtonStatus()
        if let meal = meal {
            
            navigationItem.title = meal.name
            nameTextField.text = meal.name
            photoImageView.image = meal.photo
            ratingControl.rating = meal.rating
            
        }
        
    }
    
    //MARK: Private Methods
    
    private func updateSaveButtonStatus() {
        
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
        
    }
    
    //MARK: Naigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        let name = nameTextField.text ?? ""
        let photo = photoImageView.image
        let rating = ratingControl.rating
//        meal = Meal(name: name, photo: photo, rating: rating)
        
    }
    
    //MARK: Actions


    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        
        nameTextField.resignFirstResponder()
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMealMode {
            dismiss(animated: true, completion: nil)
        } else if let owningNC = navigationController {
            owningNC.popViewController(animated: true)
        } else {
            fatalError()
        }
        
    }
    
}

//MARK: Textfield Delegate

extension MealViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonStatus()
        navigationItem.title = textField.text
    }
}

//MARK: UIImagePickerControllerDelegate

extension MealViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard  let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("Unable to pick: \(info)")
        }
        
        photoImageView.image = selectedImage
        
        dismiss(animated: true, completion: nil)
        
    }
    
}
