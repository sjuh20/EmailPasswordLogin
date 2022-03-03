//
//  ViewController.swift
//  EmailPasswordLogin
//
//  Created by Ana Brito Souza on 03/03/22.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Log In"
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        return label
        
    }()
    
    private let emailField: UITextField = {
        let emailField = UITextField()
        emailField.placeholder = " Email Address"
        emailField.layer.borderWidth = 2
        emailField.autocapitalizationType = .none
        emailField.layer.borderColor = UIColor.black.cgColor
        emailField.backgroundColor = .white
        emailField.leftViewMode = .always
        emailField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        return emailField
        
    }()
    
    private let passwordField: UITextField = {
        let passwordField = UITextField()
        passwordField.placeholder = " Password"
        passwordField.layer.borderWidth = 2
        passwordField.isSecureTextEntry = true
        passwordField.layer.borderColor = UIColor.black.cgColor
        passwordField.backgroundColor = .white
        passwordField.leftViewMode = .always
        passwordField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        return passwordField
        
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.layer.borderWidth = 2
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Continue", for: .normal)
        return button
        
    }()
    
    private let signOutButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.layer.borderWidth = 2
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Log Out", for: .normal)
        return button
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(label)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(button)
        view.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
        if FirebaseAuth.Auth.auth().currentUser != nil {
            label.isHidden = true
            button.isHidden = true
            emailField.isHidden = true
            passwordField.isHidden = true

            view.addSubview(signOutButton)
            signOutButton.frame = CGRect(x: 20, y: 150, width: view.frame.size.width-40, height: 52)
            signOutButton.addTarget(self, action: #selector(logOutTapped), for: .touchUpInside)
        }
    }
    
    @objc private func logOutTapped() {
        do {
            try FirebaseAuth.Auth.auth().signOut()
            
            label.isHidden = false
            button.isHidden = false
            emailField.isHidden = false
            passwordField.isHidden = false
            
            signOutButton.removeFromSuperview()
        }
        catch {
            print("An error occurred")
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        label.frame = CGRect(x: 0, y: 100, width: view.frame.size.width, height: 80)
        
        emailField.frame = CGRect(x: 20,
                                  y: label.frame.origin.y+label.frame.size.height+10,
                                  width: view.frame.size.width-40,
                                  height: 50)

        passwordField.frame = CGRect(x: 20,
                                     y: emailField.frame.origin.y+emailField.frame.size.height+10,
                                     width: view.frame.size.width-40,
                                     height: 50)

        button.frame = CGRect(x: 20,
                              y: passwordField.frame.origin.y+passwordField.frame.size.height+10+30,
                              width: view.frame.size.width-40,
                              height: 52)

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if FirebaseAuth.Auth.auth().currentUser == nil {
            emailField.becomeFirstResponder()

        }
    }

    @objc private func didTapButton() {
        print("Continue Button tapped")
        guard let email = emailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty else {
                  print("Missing field data")
                  return
              }
                
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: { [weak self] result, error in
            guard let strongSelf = self else {
                return
            }
            guard error == nil else {
                strongSelf.showCreateAccouny(email: email, password: password)
                return
            }
            
            print("You have signed in")
            strongSelf.label.isHidden = true
            strongSelf.emailField.isHidden = true
            strongSelf.passwordField.isHidden = true
            strongSelf.button.isHidden = true
            
            strongSelf.emailField.resignFirstResponder()
            strongSelf.passwordField.resignFirstResponder()
            
        })
        
    }
    func showCreateAccouny(email: String, password: String) {
        let alert = UIAlertController(title: "Create Account",
                                      message: "would you like to create an account",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continue",
                                      style: .default,
                                      handler: {_ in
                                        
                                        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: { [weak self]result, error in
                                            guard let strongSelf = self else {
                                                return
                                            }
                                            guard error == nil else {
                                                print("Account created failed")
                                                return
                                            }
                                            
                                            print("You have signed in")
                                            strongSelf.label.isHidden = true
                                            strongSelf.emailField.isHidden = true
                                            strongSelf.passwordField.isHidden = true
                                            strongSelf.button.isHidden = true
                                            
                                            strongSelf.emailField.resignFirstResponder()
                                            strongSelf.passwordField.resignFirstResponder()
                
            })
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: .cancel,
                                      handler: {_ in
            
        }))
         
        present(alert, animated: true)
        
    }
}

