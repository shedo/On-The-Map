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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        emailTextField.text = ""
        passwordTextField.text = ""
    }

    @IBAction func loginTapped(_ sender: Any) {
        setLogginIn(true)
        Client.login(username: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "", completion: self.handleLoginResponse(success:error:))
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        UIApplication.shared.open(Client.Endpoints.webSignUp.url, options: [:], completionHandler: nil)
    }
    
    func setLogginIn(_ loggingIn: Bool) {
        showLoader(show: loggingIn)
        emailTextField.isEnabled = !loggingIn
        passwordTextField.isEnabled = !loggingIn
        loginButton.isEnabled = !loggingIn
    }
    
    func handleLoginResponse(success: Bool, error: Error?) {
        setLogginIn(false)
        if success {
            Client.getUserData(completion: { (success, error) in
                if success {
                    let mainTabBarController = self.storyboard?.instantiateViewController(identifier: "NavigationControllerTabbar") as! UINavigationController
                    mainTabBarController.modalPresentationStyle = .fullScreen
                    self.present(mainTabBarController, animated: true, completion: nil)
                } else {
                    self.showErrorAlertDialog(title: "Error", message: error?.localizedDescription ?? "")
                }
            })
        } else {
            self.showErrorAlertDialog(title: "Login Failed", message: error?.localizedDescription ?? "")
        }
    }
}

