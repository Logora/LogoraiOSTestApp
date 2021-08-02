import UIKit

class LoginModal: UIView {
    let authService = AuthService.sharedInstance
    
    private var nextIcon = UIImageView()
    private var signInButton = TextWithLink(hyperLink: "https://demo.logora.fr", content: UtilsProvider.getLocalizedString(textKey: "already_have_account") + UtilsProvider.getLocalizedString(textKey: "login_sign_up"), clickableContent: UtilsProvider.getLocalizedString(textKey: "login_sign_up"), textType: "tertiary", textAlign: "center")
    private var content = UILabel()
    private var cguText = TextWithLink(hyperLink: "https://demo.logora.fr", content: UtilsProvider.getLocalizedString(textKey: "login_cgu"), clickableContent: UtilsProvider.getLocalizedString(textKey: "cgu"), textType: "tertiary", textAlign: "center")
    private var signUpButton = PrimaryButton(textKey: "login_sign_up")
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        initLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initLayout()
    }
    
    func initLayout() {
        if #available(iOS 13.0, *) {
            let nextIconImage = UIImage(named: "next", in: Bundle(for: type(of: self)), with: nil)
            let size = CGSize(width: 90.0, height: 90.0)
            self.nextIcon.image = nextIconImage!.resizeImage(targetSize: size)
        }
        
        self.addSubview(nextIcon)
        self.addSubview(content)
        self.addSubview(signUpButton)
        self.addSubview(signInButton)
        self.addSubview(cguText)
        self.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self)
        }
        
        self.nextIcon.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self).offset(20)
            make.centerX.equalTo(self)
        }
        
        self.content.text = UtilsProvider.getLocalizedString(textKey: "login_info")
        self.content.numberOfLines = 0
        self.content.textAlignment = .center
        self.content.setToSecondaryText()
        self.content.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.nextIcon.snp.bottom).offset(20)
            make.centerX.equalTo(self)
            make.width.lessThanOrEqualTo(self).priority(.required)
        }
        
        self.signUpButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.content.snp.bottom).offset(20)
            make.centerX.equalTo(self)
            make.width.lessThanOrEqualTo(self).priority(.required)
        }
        
        self.signInButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.signUpButton.snp.bottom).offset(20)
            make.centerX.equalTo(self)
            make.width.lessThanOrEqualTo(self).priority(.required)
        }
        
        self.cguText.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.signInButton.snp.bottom).offset(5)
            make.centerX.equalTo(self)
            make.width.lessThanOrEqualTo(self).priority(.required)
        }
        
    }
}
