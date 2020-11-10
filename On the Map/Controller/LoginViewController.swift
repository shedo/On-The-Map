//
//  ViewController.swift
//  On the Map
//
//  Created by Ivan Zandonà on 06/11/2020.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.text = ""
        passwordTextField.text = ""
    }

    @IBAction func loginTapped(_ sender: Any) {
        Client.login(username: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "", completion: self.handleLoginResponse(success:error:))
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        UIApplication.shared.open(Client.Endpoints.webSignUp.url, options: [:], completionHandler: nil)
    }
    
    func handleLoginResponse(success: Bool, error: Error?) {
        if success {
            Client.getUserData(completion: { (success, error) in
                if success {
                    let navVC = self.storyboard?.instantiateViewController(withIdentifier: "NavigationControllerTabbar") as! UINavigationController
                    self.present(navVC, animated:true, completion:nil)
                } else {
                    self.showErrorAlertDialog(title: "Error", message: error?.localizedDescription ?? "")
                }
            })
        } else {
            showErrorAlertDialog(title: "Login Failed", message: error?.localizedDescription ?? "")
        }
    }
    
    func showErrorAlertDialog(title:String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
}

