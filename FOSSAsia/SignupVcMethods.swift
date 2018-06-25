import UIKit
import SwiftValidators

extension SignUpViewController {

    func addTapGesture() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    func prepareFields() {

        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)

        confirmPasswordTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        userNameTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        firstNameTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        lastNameTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
    }

    func prepareSignUpButton() {
        // signUpButton.addTarget(self, action: #selector(performSignUp), for: .touchUpInside)
    }


    // function called on return button click of keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userNameTextField {
            _ = passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            _ = confirmPasswordTextField.becomeFirstResponder()
        }
        else if textField == confirmPasswordTextField {
            _ = firstNameTextField.becomeFirstResponder()
        }
        else if textField == firstNameTextField {
            _ = lastNameTextField.becomeFirstResponder()
        }
        else if textField == lastNameTextField {
            dismissKeyboard()
            //performSignup()
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
        userNameTextField.isEnabled = !userNameTextField.isEnabled
        passwordTextField.isEnabled = !passwordTextField.isEnabled
        confirmPasswordTextField.isEnabled = !confirmPasswordTextField.isEnabled
        signUpButton.isEnabled = !signUpButton.isEnabled
    }

    // Validate fields
    func isValid() -> Bool {

        if let password = passwordTextField.text, password.isEmpty, let confirmPassword = confirmPasswordTextField.text, confirmPassword.isEmpty {
            return false
        }
        if let password = passwordTextField.text, let confirmPassword = confirmPasswordTextField.text, password != confirmPassword {
            return false
        }

        return true
    }

}
