import UIKit
import Material

class LoginViewController: UIViewController {


    @IBOutlet weak var userNameTextField: TextField!
    @IBOutlet weak var passwordTextField: TextField!
    @IBOutlet weak var loginButton: RaisedButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        addTapGesture()
        prepareUserNameField()
        preparePasswordField()
        prepareLoginButton()
    }

    override func viewDidAppear(_ animated: Bool) {
        self.parent?.navigationItem.title = "Login"
    }


}
