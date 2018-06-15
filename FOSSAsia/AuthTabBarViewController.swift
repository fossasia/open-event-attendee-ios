import UIKit

class AuthTabBarViewController: UITabBarController {

    @IBOutlet weak var backButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.parent?.navigationItem.backBarButtonItem = nil

        // Do any additional setup after loading the view.
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let vc: UITabBarController = mainStoryboard.instantiateViewController(withIdentifier: "tabBarController") as? UITabBarController else {
            fatalError("Cannot Cast to UITabBarController")
        }
        vc.selectedIndex = 0
        self.present(vc, animated: true, completion: nil)
    }

}
