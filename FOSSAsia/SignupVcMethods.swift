import UIKit
import SwiftValidators
import Alamofire
import Toast_Swift

extension SignUpViewController {

    func addTapGesture() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    func prepareFields() {

        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)

        confirmPasswordTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        firstNameTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        lastNameTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
    }

    func prepareSignUpButton() {
        signUpButton.addTarget(self, action: #selector(performSignup), for: .touchUpInside)
    }



    @objc func performSignup() {
        if isValid() {
            self.signupActivityIndicator.isHidden = false
            self.signupActivityIndicator.startAnimating()
            let email = emailTextField.text?.lowercased()
            let password = passwordTextField.text
            let firstName = firstNameTextField.text
            let lastName = lastNameTextField.text
            let params: [String: Any] = [
                Constants.UserDefaultsKey.dataJsonKey: [
                    Constants.UserDefaultsKey.attributesJsonKey: [
                        Constants.UserDefaultsKey.emailJsonKey: email,
                        Constants.UserDefaultsKey.passwordJsonKey: password,
                    ],
                    Constants.UserDefaultsKey.typeJsonKey: Constants.UserDefaultsKey.userJsonValue
                ]

            ]
            let paramsLogin: [String: AnyObject] = [

                Constants.UserDefaultsKey.emailJsonKey: email as AnyObject,
                Constants.UserDefaultsKey.passwordJsonKey: password as AnyObject

            ]

            Client.sharedInstance.registerUser(params as [String: AnyObject]) { (success, message) in
                DispatchQueue.main.async {
                    self.toggleEditing()
                    if success {
                        Client.sharedInstance.loginUser(paramsLogin as [String: AnyObject]) { (success, result, message) in
                            DispatchQueue.main.async {
                                if success {
                                    self.signupActivityIndicator.stopAnimating()
                                    guard let accessToken = result?["access_token"] as? String else {
                                        fatalError("Unable to Fetch AccessToken")
                                    }
                                    self.view.makeToast(Constants.ResponseMessages.successMessageSignup)
                                    UserDefaults.standard.set(firstName, forKey: Constants.UserDefaultsKey.firstName)
                                    UserDefaults.standard.set(lastName, forKey: Constants.UserDefaultsKey.lastName)
                                    UserDefaults.standard.set(accessToken, forKey: Constants.UserDefaultsKey.acessToken)
                                    let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                                    guard let vc: UITabBarController = mainStoryboard.instantiateViewController(withIdentifier: "tabBarController") as? UITabBarController else {
                                        fatalError("Cannot Cast to UITabBarController")
                                    }
                                    vc.selectedIndex = 0
                                    self.present(vc, animated: true, completion: nil)

                                }
                                else {
                                    self.signupActivityIndicator.stopAnimating()
                                    self.view.makeToast(message)
                                    self.toggleEditing()
                                }

                            }
                        }


                    }

                }
            }
        }
        else {
            self.view.makeToast(Constants.ResponseMessages.checkParameter)
        }



    }

    // function called on return button click of keyboard
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
        } else if textField == confirmPasswordTextField, let password = passwordTextField.text, let confirmPassword = confirmPasswordTextField.text {
            if password != confirmPassword {
                confirmPasswordTextField.dividerActiveColor = .red
            } else {
                confirmPasswordTextField.dividerActiveColor = .green
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
        confirmPasswordTextField.isEnabled = !confirmPasswordTextField.isEnabled
        signUpButton.isEnabled = !signUpButton.isEnabled
    }

    // Validate fields
    func isValid() -> Bool {
        if let emailID = emailTextField.text, !emailID.isValidEmail() {
            return false
        }

        if let password = passwordTextField.text, password.isEmpty, let confirmPassword = confirmPasswordTextField.text, confirmPassword.isEmpty {
            return false
        }
        if let password = passwordTextField.text, let confirmPassword = confirmPasswordTextField.text, password != confirmPassword {
            return false
        }

        return true
    }

}
