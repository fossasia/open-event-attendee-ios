import UIKit

class AuthTabBarViewController: UITabBarController {

    @IBOutlet weak var backButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.parent?.navigationItem.backBarButtonItem = nil
        let button =  UIButton(type: .custom)
        button.setImage(UIImage(named: "back"), for: .normal)
        button.addTarget(self, action: #selector(AuthTabBarViewController.backAction), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 53, height: 31)
        button.imageEdgeInsets = UIEdgeInsetsMake(1, -32, 1, 32)//move image to the right
        let label = UILabel(frame: CGRect(x: 3, y: 5, width: 50, height: 20))
        label.text = "Back"
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.backgroundColor =   UIColor.clear
        button.addSubview(label)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = barButton

        // Do any additional setup after loading the view.
    }
    
     @objc func backAction()
     {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let vc: UITabBarController = mainStoryboard.instantiateViewController(withIdentifier: "tabBarController") as? UITabBarController else {
            fatalError("Cannot Cast to UITabBarController")
        }
        vc.selectedIndex = 0
        self.present(vc, animated: true, completion: nil)
        
    }

}
