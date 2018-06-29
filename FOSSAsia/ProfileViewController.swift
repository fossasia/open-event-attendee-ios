import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profileImageView: UIImageView!
    var imagePicker: UIImagePickerController!

    @IBOutlet weak var userName: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setImageView()
        addTapGesture()
        setUserName()
        setBackButton()


        // Do any additional setup after loading the view.

    }

    func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAvatar))
        profileImageView.addGestureRecognizer(tap)
        profileImageView.isUserInteractionEnabled = true
    }


    @objc func tapAvatar() {
        let imagePickerController = UIImagePickerController()

        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary

        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {

        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }

        // Set photoImageView to display the selected image.
        profileImageView.image = selectedImage

        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }

    func setUserName() {
        if UserDefaults.exists(key: Constants.UserDefaultsKey.firstName) {
            userName.text = UserDefaults.standard.string(forKey: Constants.UserDefaultsKey.firstName)
        }
    }

    func setImageView() {
        profileImageView.layer.borderWidth = 1.0
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.clipsToBounds = true
    }


    func setBackButton() {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "back"), for: .normal)
        button.addTarget(self, action: #selector(AuthTabBarViewController.backAction), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 53, height: 31)
        button.imageEdgeInsets = UIEdgeInsetsMake(1, -32, 1, 32)
        let label = UILabel(frame: CGRect(x: 3, y: 5, width: 50, height: 20))
        label.text = "Back"
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.clear
        button.addSubview(label)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = barButton
    }


    @objc func backAction() {

        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let vc: UITabBarController = mainStoryboard.instantiateViewController(withIdentifier: "tabBarController") as? UITabBarController else {
            fatalError("Cannot Cast to UITabBarController")
        }
        vc.selectedIndex = 0
        self.present(vc, animated: true, completion: nil)

    }




}
