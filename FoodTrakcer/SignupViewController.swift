//
//  SignupViewController.swift
//  FoodTrakcer
//
//  Created by Dayson Dong on 2019-06-10.
//  Copyright © 2019 Dayson Dong. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {

    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    var postData: [String: Any]!
    var networkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    @IBAction func logInButtonTapped(_ sender: UIButton) {
                
        checkText()
        
        networkManager.post(data: postData, toEndpoint: "/login") { (data, response, error) -> (Void) in
            
            guard let data = data else {
                self.presentAlertWith(title: "Failed", message: "Please try again!")
                print("data error")
                return
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else {
                self.presentAlertWith(title: "Failed", message: "Please try again!")
                print("data not valid")
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                self.presentAlertWith(title: "Failed", message: "Please try again!")
                print("response error")
                return
            }
            
            guard response.statusCode == 200 else {
                self.presentAlertWith(title: "Failed", message: "Please try again!")
                print("status code: \(response.statusCode)")
                return
            }
            
            guard let userInfo = json as? [String: Any] else {
                self.presentAlertWith(title: "Failed", message: "Please try again!")
                print("could not parsed json")
                return
            }
            
            print("succeed")
            
            UserDefaults.standard.set(userInfo["username"], forKey: "username")
            UserDefaults.standard.set(userInfo["password"], forKey: "password")
            UserDefaults.standard.set(userInfo["token"], forKey: "token")
            UserDefaults.standard.set(true, forKey: "hasSignedUp" )
            
            self.dismiss(animated: true, completion: nil)
            
        }
        
        
    }
    
    @IBAction func signupButtonTapped(_ sender: UIButton) {
        
        checkText()
        signup()

    }
    
    private func checkText() {
        
        guard usernameTextField.text?.isEmpty == false else {
            presentAlertWith(title: "Invalid Username", message: "Please enter username!")
            return
        }
        guard passwordTextField.text?.isEmpty == false else {
            presentAlertWith(title: "Invalid Password", message: "Please enter password!")
            return
        }
        guard usernameTextField.text!.count >= 6 else {
            presentAlertWith(title: "Username length less than 6", message: "Please use another username!")
            return
        }
        
        guard passwordTextField.text!.count >= 6 else {
            presentAlertWith(title: "Password length less than 6", message: "Please use another password!")
            return
        }
        
        let username = usernameTextField.text!
        let password = passwordTextField.text!
        
        postData = ["username": username, "password": password]
    }
    
    //MARK: Private Methods
    
    private func presentAlertWith(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
    private func signup() {
        
        networkManager.post(data: postData, toEndpoint: "/signup") { (data, response, error) -> (Void) in
            
            guard let data = data else {
                self.presentAlertWith(title: "Failed", message: "Please try again!")
                print("data error")
                return
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else {
                self.presentAlertWith(title: "Failed", message: "Please try again!")
                print("data not valid")
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                self.presentAlertWith(title: "Failed", message: "Please try again!")
                print("response error")
                return
            }
            
            guard response.statusCode == 200 else {
                self.presentAlertWith(title: "Failed", message: "Please try again!")
                print("status code: \(response.statusCode)")
                return
            }
            
            guard let userInfo = json as? [String: Any] else {
                self.presentAlertWith(title: "Failed", message: "Please try again!")
                print("could not parsed json")
                return
            }
            
            print("succeed")
            
            UserDefaults.standard.set(userInfo["username"], forKey: "username")
            UserDefaults.standard.set(userInfo["password"], forKey: "password")
            UserDefaults.standard.set(userInfo["token"], forKey: "token")
            UserDefaults.standard.set(true, forKey: "hasSignedUp" )
            
            self.dismiss(animated: true, completion: nil)
            
        }
    }
    
}





extension SignupViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField === usernameTextField {
            passwordTextField.becomeFirstResponder()
        }
        
        if textField === passwordTextField {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    
}
