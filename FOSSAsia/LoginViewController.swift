import UIKit
import Material

class LoginViewController: UIViewController,UITextFieldDelegate {


    @IBOutlet weak var userNameTextField: TextField!
    @IBOutlet weak var passwordTextField: TextField!
    @IBOutlet weak var loginButton: RaisedButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        addTapGesture()
        prepareUserNameField()
        preparePasswordField()
        prepareLoginButton()
        userNameTextField.delegate = self
        passwordTextField.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        self.parent?.navigationItem.title = "Login"
    }


}
