//
//  ViewController.swift
//  OnTheMap
//
//  Created by Chris Eadie on 11/12/2020.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTextFieldDelegates()
    }
    
    @IBAction func logInButtonTapped(_ sender: Any) {
        guard let username = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        
        UdacityClient.postSession(username: username, password: password, completion: handleSessionResponse(success:errorMessage:))
    }
    
    func handleSessionResponse(success: Bool, errorMessage: String?) {
        if success {
            print("Logged in")
            goBack()
            return
        } else {
            let errorMessage = errorMessage ?? "Unable to login in"
            let ac = UIAlertController(title: "Login failed", message: errorMessage, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(ac, animated: true, completion: nil)
            return
        }
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    
    func setTextFieldDelegates() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if emailTextField.hasText && passwordTextField.hasText {
            let username = emailTextField.text!
            let password = passwordTextField.text!
            UdacityClient.postSession(username: username, password: password, completion: handleSessionResponse(success:errorMessage:))
        }
        
        if let nextResponder = textField.superview?.viewWithTag(textField.tag + 1) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
}

extension LoginViewController: UINavigationControllerDelegate {
    
    func goBack() {
        navigationController?.popViewController(animated: true)
    }
}
