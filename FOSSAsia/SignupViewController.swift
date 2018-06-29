import UIKit
import Material
class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var passwordTextField: TextField!
    @IBOutlet weak var confirmPasswordTextField: TextField!
    @IBOutlet weak var firstNameTextField: TextField!

    @IBOutlet weak var emailTextField: TextField!
    @IBOutlet weak var lastNameTextField: TextField!

    @IBOutlet weak var signUpButton: RaisedButton!

    @IBOutlet weak var signupActivityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        addTapGesture()
        prepareFields()
        prepareSignUpButton()
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        self.parent?.navigationItem.title = "Signup"
    }

}
