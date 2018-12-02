//
//  SignUpViewController.swift
//  finalprojecttrail
//
//  Created by Ruoyu Li on 11/24/18.
//  Copyright © 2018 Ruoyu Li. All rights reserved.
//

import UIKit
import FirebaseAuth
import ChameleonFramework

class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var UsernameTextField: UITextField!
    
    @IBOutlet weak var EmailTextField: UITextField!
    
    @IBOutlet weak var PasswordTextField: UITextField!
    
    @IBOutlet weak var VerifyTextField: UITextField!
    
    var userEmail = ""
    var userName = ""
    var userPassword = ""
    var userVerifiedPassWord = ""
    
    
    @IBAction func SignUpPressed(_ sender: UIButton) {
        guard let email = EmailTextField.text else { return }
        guard let password = PasswordTextField.text else { return }
        guard let name = UsernameTextField.text else { return }
        guard let verifiedPassword = VerifyTextField.text else { return }
        if email == "" || password == "" || name == "" || verifiedPassword == "" {
            let alertController = UIAlertController(title: "Form Error.", message: "Please fill in form completely.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
            
        } else {
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                if error == nil {
                    // TO DO:
                    // The user account has been successfully created. Now, update the user's name in
                    // firebase and then perform a segue to the main page. Note, again, that this segue
                    // already exists somewhere, just do some simple debugging to find the identifier.
                    // Also, notify the user that the account has been successfully created before
                    // performing the segue.
                    
                    let changeRequest = user?.user.createProfileChangeRequest()
                    changeRequest!.displayName = name
                    changeRequest!.commitChanges(completion: { (err) in
                        if let err = err {
                            print("Stop over here there is an error")
                            print(err)
                        }
                        else {
                            print("No error at all when create")
                            self.performSegue(withIdentifier: "signUpToMainPage", sender: self)
                            
                            //so successfuly create the email
                        }
                    })
                    
                    
                    
                    //need to send a email to verif
                    
                } else if password != verifiedPassword {
                    
                    let alertController = UIAlertController(title: "Verification Error.", message: "The two passwords do not match.", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.VerifyTextField.textColor = UIColor.red
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    let alertController = UIAlertController(title: "Sign Up Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.flatLime()
        
        self.UsernameTextField.delegate = self
        
        self.EmailTextField.delegate = self
        self.PasswordTextField.delegate = self
        self.VerifyTextField.delegate = self
        self.UsernameTextField.backgroundColor = UIColor.flatSandColorDark()
        self.PasswordTextField.backgroundColor = UIColor.flatSandColorDark()
        self.VerifyTextField.backgroundColor = UIColor.flatSandColorDark()
        self.EmailTextField.backgroundColor = UIColor.flatSandColorDark()
        // Do any additional setup after loading the view.
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.EmailTextField {
            if textField.text != nil {
                self.userEmail = textField.text!
            }
        } else if textField == self.PasswordTextField {
            if textField.text != nil {
                self.userPassword = textField.text!
            }
        } else if textField == self.UsernameTextField {
            if textField.text != nil {
                self.userName = textField.text!
            }
        } else if textField == self.VerifyTextField {
            if textField.text != nil {
                self.userVerifiedPassWord = textField.text!
            }
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

}
