import UIKit

extension UILabel {
    func underline() {
        if let textString = self.text {
          let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle,
                                          value: NSUnderlineStyle.single.rawValue,
                                          range: NSRange(location: 0, length: attributedString.length))
          attributedText = attributedString
        }
    }
    
    func setToItalic() {
        self.font = UIFont.italicSystemFont(ofSize: self.font.pointSize)
    }
    
    func setToBold() {
        self.font = UIFont.boldSystemFont(ofSize: self.font.pointSize)
    }
    
    func setToNormal() {
        self.font = UIFont.systemFont(ofSize: self.font.pointSize)
    }
    
    func setToTitle() {
        self.font = UIFont.systemFont(ofSize: 25.0)
    }
    
    func setToSubtitle() {
        self.font = UIFont.systemFont(ofSize: 20.0)
    }
    
    func setToSecondaryText() {
        self.font = UIFont.systemFont(ofSize: 15.0)
    }
    
    func setToSecondaryTextColor() {
        self.textColor = UIColor(hexString: SettingsProvider.sharedInstance.textSecondary)
    }
    
    func setToTertiaryText() {
        self.font = UIFont.systemFont(ofSize: 13.0)
    }
    
    func setToTertiaryTextColor() {
        self.textColor = UIColor(hexString: SettingsProvider.sharedInstance.textTertiary)
    }
    
    func setRegularAndBoldText(regularText: String, boldText: String) {
        let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: font.pointSize)]
        let regularString = NSMutableAttributedString(string: regularText)
        let boldString = NSMutableAttributedString(string: boldText, attributes:attrs)
        regularString.append(boldString)
        attributedText = regularString
    }
}
