import UIKit
import Material

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: TextField!
    @IBOutlet weak var passwordTextField: TextField!
    @IBOutlet weak var loginButton: RaisedButton!
    @IBOutlet weak var loginActivityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        addTapGesture()
        prepareUserNameField()
        preparePasswordField()
        prepareLoginButton()
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        self.parent?.navigationItem.title = "Login"
    }


}
