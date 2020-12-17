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
        // Do any additional setup after loading the view.
        setTextFieldDelegates()
    }
    
    
    @IBAction func logInButtonTapped(_ sender: Any) {
        guard let username = emailTextField.text, let password = passwordTextField.text else {
            // FIXME: Display alert requesting username and password be entered
            return
        }
        
        OnTheMapAPI.postSession(username: username, password: password, completion: handleSessionResponse(sessionId:error:))
    }
    
    func handleSessionResponse(sessionId: String?, error: Error?) {
        if let sessionId = sessionId {
            Session.id = sessionId
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
            // Log in
        }
        
        if let nextResponder = textField.superview?.viewWithTag(textField.tag + 1) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
}
