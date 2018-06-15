import UIKit

class Bordered_Button: UIButton {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.borderWidth = 1.0
        layer.borderColor = Colors.statusBarOrangeColor?.cgColor
        clipsToBounds = true
    }
}
