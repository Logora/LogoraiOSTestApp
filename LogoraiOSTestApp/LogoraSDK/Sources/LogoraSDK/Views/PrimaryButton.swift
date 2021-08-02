import UIKit

class PrimaryButton: UIButton {
    let settings: SettingsProvider = SettingsProvider.sharedInstance
    private var textKey: String!
    
    required init(value: Int = 0, textKey: String) {
        super.init(frame: .zero)
        self.textKey = textKey
        
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.textKey = ""
        
        setup()
    }

    func setup() {
        let primaryColorCode = settings.get(key: "theme.callPrimaryColor")
        self.backgroundColor = UIColor.init(hexString: primaryColorCode)
        
        let textValue = UtilsProvider.getLocalizedString(textKey: self.textKey)
        if(!textValue.isEmpty) {
            self.setTitle(textValue, for: .normal)
            self.uppercased()
        } else {
            self.setTitle(NSLocalizedString(self.textKey, comment: ""), for: .normal)
            self.uppercased()
        }
        self.sizeToFit()
        self.layer.cornerRadius = 6
        self.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        self.addBorder(hexString: SettingsProvider.sharedInstance.getTheme(key: "borderBoxColor"), width: 0.2)
        self.addShadow(offset: CGSize.init(width: 0, height: 1), color: UIColor.init(hexString: SettingsProvider.sharedInstance.getTheme(key: "borderBoxColor")), radius: 4, opacity: 0.35)
    }
}
