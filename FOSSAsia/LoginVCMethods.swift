import UIKit
import SwiftValidators

extension LoginViewController {

    func addTapGesture() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }


    func prepareUserNameField() {

        userNameTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
    }

    // Configures Password Text Field
    func preparePasswordField() {

        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
    }



    // Configure Login Button
    func prepareLoginButton() {
        //    loginButton.addTarget(self, action: #selector(performLogin), for: .touchUpInside)
    }

    // Keyboard Return Key Hit
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userNameTextField {
            _ = passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            dismissKeyboard()
            // performLogin()
        }
        return false
    }

    @objc func textFieldDidChange(textField: UITextField) {
        if textField == userNameTextField, let userName = userNameTextField.text {
            if userName.isEmpty {
                userNameTextField.dividerActiveColor = .red
            } else {
                userNameTextField.dividerActiveColor = .green
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
        userNameTextField.isEnabled = !userNameTextField.isEnabled
        passwordTextField.isEnabled = !passwordTextField.isEnabled
        loginButton.isEnabled = !loginButton.isEnabled
    }

    // Clear field after login
    func clearFields() {
        passwordTextField.text = ""
    }

    // Validate fields
    func isValid() -> Bool {
        if let userName = userNameTextField.text, userName.isEmpty {
            return false
        }
        if let password = passwordTextField.text, password.isEmpty {
            return false
        }

        return true
    }

}
