import UIKit

class DecisionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        setAuthentication()
    }

    func setAuthentication() {
        if UserDefaults.exists(key: Constants.UserDefaultsKey.acessToken) {
            let profileStoryboard = UIStoryboard(name: "Profile", bundle: Bundle.main)
            let profileVC = profileStoryboard.instantiateViewController(withIdentifier: "ProfileViewController")
            self.navigationController?.pushViewController(profileVC, animated: false)
        } else {
            let profileStoryboard = UIStoryboard(name: "Profile", bundle: Bundle.main)
            guard let vc: UITabBarController = profileStoryboard.instantiateViewController(withIdentifier: "AuthTabBarController") as? UITabBarController else {
                fatalError("Cannot Cast to UITabBarController")
            }
            vc.selectedIndex = 0
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }

}
