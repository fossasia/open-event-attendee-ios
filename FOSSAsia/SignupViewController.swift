import UIKit
import Material
class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var passwordTextField: TextField!
    @IBOutlet weak var confirmPasswordTextField: TextField!
    @IBOutlet weak var firstNameTextField: TextField!

    @IBOutlet weak var userNameTextField: TextField!
    @IBOutlet weak var lastNameTextField: TextField!

    @IBOutlet weak var signUpButton: RaisedButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        addTapGesture()
        prepareFields()
        prepareSignUpButton()
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        userNameTextField.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        self.parent?.navigationItem.title = "Signup"
    }

}
