import UIKit
import SwiftValidators

extension LoginViewController {

    func addTapGesture() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }


    func prepareUserNameField() {

        emailTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
    }

    // Configures Password Text Field
    func preparePasswordField() {

        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
    }



    // Configure Login Button
    func prepareLoginButton() {
        loginButton.addTarget(self, action: #selector(performLogin), for: .touchUpInside)
    }

    @objc func performLogin() {
        if isValid() {
            self.loginActivityIndicator.isHidden = false
            self.loginActivityIndicator.startAnimating()
            let email = emailTextField.text?.lowercased()
            let password = passwordTextField.text
            let params: [String: AnyObject] = [

                Constants.UserDefaultsKey.emailJsonKey: email as AnyObject,
                Constants.UserDefaultsKey.passwordJsonKey: password as AnyObject

            ]

            Client.sharedInstance.loginUser(params as [String: AnyObject]) { (success, result, message) in
                DispatchQueue.main.async {
                    self.loginActivityIndicator.stopAnimating()
                    self.toggleEditing()
                    if success {
                        self.view.makeToast(message)
                        guard let accessToken = result?["access_token"] as? String else {
                            fatalError("Unable to Fetch AccessToken")
                        }
                        UserDefaults.standard.set(accessToken, forKey: Constants.UserDefaultsKey.acessToken)
                        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                        guard let vc: UITabBarController = mainStoryboard.instantiateViewController(withIdentifier: "tabBarController") as? UITabBarController else {
                            fatalError("Cannot Cast to UITabBarController")
                        }
                        vc.selectedIndex = 0
                        self.present(vc, animated: true, completion: nil)

                    }
                    else {
                        self.view.makeToast(message)
                         self.toggleEditing()
                    }

                }
            }
        }
        else {
            self.view.makeToast(Constants.ResponseMessages.checkParameter)
        }

    }

    // Keyboard Return Key Hit
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @objc func textFieldDidChange(textField: UITextField) {
        if textField == emailTextField, let emailID = emailTextField.text {
            if !emailID.isValidEmail() {
                emailTextField.dividerActiveColor = .red
            } else {
                emailTextField.dividerActiveColor = .green
            }
        } else if textField == passwordTextField, let password = passwordTextField.text {
            if password.isEmpty || password.count < 5 {
                passwordTextField.dividerActiveColor = .red
            } else {
                passwordTextField.dividerActiveColor = .green
            }
        }
    }

    // force dismiss keyboard if open.
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    // Toggle Editing
    func toggleEditing() {
        emailTextField.isEnabled = !emailTextField.isEnabled
        passwordTextField.isEnabled = !passwordTextField.isEnabled
        loginButton.isEnabled = !loginButton.isEnabled
    }

    // Clear field after login
    func clearFields() {
        passwordTextField.text = ""
    }

    // Validate fields
    func isValid() -> Bool {
        if let emailID = emailTextField.text, !emailID.isValidEmail() {
            return false
        }

        if let password = passwordTextField.text, password.isEmpty {
            return false
        }

        return true
    }

}
