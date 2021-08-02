import UIKit

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder?.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    func addBottomBorderWithColor(color: String, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = UIColor.init(hexString: color).cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        if #available(iOS 11, *) {
            var cornerMask = CACornerMask()
            if(corners.contains(.topLeft)){
                cornerMask.insert(.layerMinXMinYCorner)
            }
            if(corners.contains(.topRight)){
                cornerMask.insert(.layerMaxXMinYCorner)
            }
            if(corners.contains(.bottomLeft)){
                cornerMask.insert(.layerMinXMaxYCorner)
            }
            if(corners.contains(.bottomRight)){
                cornerMask.insert(.layerMaxXMaxYCorner)
            }
            self.layer.cornerRadius = radius
            self.layer.maskedCorners = cornerMask

        } else {
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.layer.mask = mask
        }
    }
    
    func addBorder(hexString: String, width: CGFloat){
        self.layer.borderWidth = width
        self.layer.cornerRadius = 6
        self.layer.borderColor = UIColor.init(hexString: hexString).cgColor
    }
    
    func addShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
        self.layer.masksToBounds = false
        self.layer.shadowOffset = offset
        self.layer.shadowColor = color.cgColor
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = opacity

        let backgroundCGColor = backgroundColor?.cgColor
        self.backgroundColor = nil
        self.layer.backgroundColor =  backgroundCGColor
    }
    
    var heightConstraint: NSLayoutConstraint? {
        get {
            return constraints.first(where: {
                $0.firstAttribute == .height && $0.relation == .equal
            })
        }
        set { setNeedsLayout() }
    }

    
    func setOnClickListener(action: @escaping (_: Any?) -> Void, clickedObject: Any? = nil){
        let tapRecogniser = ClickListener(target: self, action: #selector(onViewClicked), clickedObject: clickedObject, onClick: action)
        self.addGestureRecognizer(tapRecogniser)
    }
    
    @objc func onViewClicked(_ sender: ClickListener) {
        sender.onClick?(sender.clickedObject)
    }
}

