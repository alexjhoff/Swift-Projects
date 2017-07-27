//
//  LoginRegisterViewController.swift
//  ChatApp
//
//  Created by Alex Hoff on 7/25/17.
//  Copyright © 2017 Alex Hoff. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginRegisterViewController: UIViewController {


    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginRegisterViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginClicked(_ sender: Any) {
    
        if(!CheckInput()) {
            return
        }
        
        let email = emailTextField.text
        let password = passwordTextField.text
        
        Auth.auth().signIn(withEmail: email!, password: password!, completion:
            { (user, error) in
                if let error = error{
                    Utilities().ShowAlert(title: "Error!", message: error.localizedDescription, vc: self)
                    print(error.localizedDescription)
                    return
                }
                print("Signed in!")
        })
        
    }
    
    func CheckInput() -> Bool {
        
        if((emailTextField.text?.characters.count)! < 5){
            emailTextField.backgroundColor = UIColor.init(red: 0.8, green: 0, blue: 0, alpha: 0.2)
            return false
        }else{
            emailTextField.backgroundColor = UIColor.white
        }
        if((passwordTextField.text?.characters.count)! < 5){
            passwordTextField.backgroundColor = UIColor.init(red: 0.8, green: 0, blue: 0, alpha: 0.2)
            return false
        }else{
            passwordTextField.backgroundColor = UIColor.white
        }
        return true
    }

    @IBAction func registerClicked(_ sender: Any) {
        
        if(!CheckInput()) {
            return
        }
        
        let alert = UIAlertController(title: "Register", message: "Please confirm password...", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "password"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            let passConfirm = alert.textFields![0] as UITextField
            if(passConfirm.text!.isEqual(self.passwordTextField.text!)) {
            
                //registration begins
                let email = self.emailTextField.text
                let password = self.passwordTextField.text
                Auth.auth().createUser(withEmail: email!, password: password!, completion: { (user, error) in
                    if let error = error {
                        Utilities().ShowAlert(title: "Error", message: error.localizedDescription, vc: self)
                        return
                    }
                    self.dismiss(animated: true, completion: nil)
                })
            }else {
                Utilities().ShowAlert(title: "Error", message: "Passwords not the same!", vc: self)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func forgotClicked(_ sender: Any) {
        
        if(!emailTextField.text!.isEmpty) {
            let email = self.emailTextField.text
            
            Auth.auth().sendPasswordReset(withEmail: email!, completion: { (error) in
                if let error = error {
                    Utilities().ShowAlert(title: "Error", message: error.localizedDescription, vc: self)
                }
                Utilities().ShowAlert(title: "Success", message: "Please check your email to reset your password!", vc: self)
            })
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
