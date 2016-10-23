//
//  LoginViewController.swift
//  Events
//
//  Created by Athul Sai on 23/10/16.
//  Copyright © 2016 Athul Sai. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.becomeFirstResponder()
        nameTextField.addTarget(self, action: #selector(self.alertTextFieldDidChange), for:UIControlEvents.editingChanged)
        loginButton.isEnabled = false
    }
    
    func alertTextFieldDidChange() {
        loginButton.isEnabled = !(nameTextField.text?.isEmpty)!
    }
    
    //MARK: - Login Action
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        UserDefaults.standard.set(nameTextField.text!, forKey: "name")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RootViewController") as! RootViewController
        let navController = UINavigationController(rootViewController: vc)
        DataAccess.sharedAccess.fetchUserData(name: nameTextField.text!)
        if DataAccess.sharedAccess.currentUser == nil {
            DataAccess.sharedAccess.saveUserData(name: nameTextField.text!)
            DataAccess.sharedAccess.fetchUserData(name: nameTextField.text!)
            self.navigationController?.present(navController, animated: true, completion: nil)
        } else {
            self.navigationController?.present(navController, animated: true, completion: nil)
        }
    }
}
