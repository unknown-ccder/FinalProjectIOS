//
//  LoginViewController.swift
//  finalprojecttrail
//
//  Created by Ruoyu Li on 11/23/18.
//  Copyright © 2018 Ruoyu Li. All rights reserved.
//

import UIKit
import FirebaseAuth
import ChameleonFramework

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    //2 user box
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    var userEmail = ""
    var userPassword = ""
    
    
    @IBAction func LoginPressed(_ sender: UIButton) {
        guard let emailText = emailTextField.text else { return }
        guard let passwordText = passwordTextField.text else { return }
        
        if emailText == "" || passwordText == "" {
            //Alert to tell the user that there was an error because they didn't fill anything in the textfields
            let alertController = UIAlertController(title: "Log In Error", message: "Please enter an email and password.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else {
            // email and password fields are not blank, let's try logging in the user!
            // you'll need to use `emailText` and `passwordText`, and a method found in this
            // api doc https://firebase.google.com/docs/auth/ios/start
            // if the error == nil, segue to the main page using `performSegue` with identifier
            // `segueLogInToMainPage`
            // if there is an error signing in (error != nil), present the following alert:
            
//                let alertController = UIAlertController(title: "Log In Error", message:
//                                    error?.localizedDescription, preferredStyle: .alert)
//                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//                alertController.addAction(defaultAction)
//                self.present(alertController, animated: true, completion: nil)
//
            Auth.auth().signIn(withEmail: emailText, password: passwordText, completion: { (user, error) in
                if let error = error {
                    print(error)
                } else {
                    self.performSegue(withIdentifier: "logInToMainPage", sender: self)
                }
            })
        }
    }
    
    
    @IBAction func SignUpPressed(_ sender: UIButton) {
        performSegue(withIdentifier:segueLogInToSignUp, sender: self)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.flatLime()
        
        self.emailTextField.delegate = self
        self.emailTextField.backgroundColor = UIColor.flatSandColorDark()
        self.passwordTextField.delegate = self
        self.passwordTextField.backgroundColor = UIColor.flatSandColorDark()


        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        //YOUR CODE HERE
        
        if Auth.auth().currentUser != nil {
            print("who is users")
            self.performSegue(withIdentifier: "logInToMainPage", sender: self)
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.emailTextField {
            if textField.text != nil {
                self.userEmail = textField.text!
            }
        } else {
            if textField.text != nil {
                self.userPassword = textField.text!
            }
        }
    }

}
