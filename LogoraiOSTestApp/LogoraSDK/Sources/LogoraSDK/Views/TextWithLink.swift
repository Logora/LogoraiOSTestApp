import UIKit

class TextWithLink: UITextView {
    private final var settings = SettingsProvider.sharedInstance
    private var hyperLink: String!
    private var content: String!
    private var clickableContent: String!
    private var textType: String!
    private var textAlign: String!
    
    required init(hyperLink: String, content: String, clickableContent: String, textType: String, textAlign: String) {
        super.init(frame: .zero, textContainer: nil)
        self.hyperLink = hyperLink
        self.content = content
        self.clickableContent = clickableContent
        self.textType = textType
        self.textAlign = textAlign
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.hyperLink = ""
        self.content = ""
        self.clickableContent = ""
        self.textType = ""
        self.textAlign = ""
        setup()
    }
    
    func setup() {
        let range = content.range(of: clickableContent)
        let startingRange = content.distance(from: clickableContent.startIndex, to: range!.lowerBound)
        let attributedString = NSMutableAttributedString(string: self.content)
        let url = URL(string: self.hyperLink)!
        attributedString.setAttributes([.link: url], range: NSMakeRange(startingRange, clickableContent.count))

        self.attributedText = attributedString
        self.isUserInteractionEnabled = true
        self.isEditable = false
        let primaryColorCode = settings.get(key: "theme.callPrimaryColor")
        self.linkTextAttributes = [
            .foregroundColor: UIColor.init(hexString: primaryColorCode),
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        self.sizeToFit()
        self.isScrollEnabled = false
        self.setTextType()
        self.setTextAlign()
        self.snp.makeConstraints{(make) -> Void in
            make.edges.equalTo(self)
        }
    }
    
    func setTextType() {
        switch(self.textType) {
        case "primary":
            self.font = UIFont.systemFont(ofSize: 17.0)
        case "secondary":
            self.font = UIFont.systemFont(ofSize: 15.0)
            self.textColor = UIColor(hexString: SettingsProvider.sharedInstance.textSecondary)
        case "tertiary":
            self.font = UIFont.systemFont(ofSize: 13.0)
            self.textColor = UIColor(hexString: SettingsProvider.sharedInstance.textSecondary)
        default:
            self.font = UIFont.systemFont(ofSize: 17.0)
        }
    }
    
    func setTextAlign() {
        switch(self.textAlign) {
            case "center":
                self.textAlignment = .center
            case "right":
                self.textAlignment = .right
            case "left":
                self.textAlignment = .left
            default :
                self.textAlignment = .center
        }
    }
    
}
