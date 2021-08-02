import UIKit

extension UITextField {
    func underline() {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: 75 - 1, width: 300, height: 1.0)
        bottomLine.backgroundColor = UIColor.white.cgColor
        self.borderStyle = .none
        self.layer.addSublayer(bottomLine)
    }
}
