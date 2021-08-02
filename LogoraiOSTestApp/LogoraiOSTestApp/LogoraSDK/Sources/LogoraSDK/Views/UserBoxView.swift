
import UIKit
import Kingfisher
import SnapKit

class UserTapGestureRecognizer: UITapGestureRecognizer {
    var userSlug: String? = ""
}

class UserBoxView: UITableViewCell, CellElement {
    @IBOutlet weak var userBoxImage: UIImageView!
    @IBOutlet weak var userBoxFullName: UILabel!
    @IBOutlet weak var userBoxLevel: UILabel!
    @IBOutlet weak var userBoxLevelIcon: UIImageView!
    
    var user: User!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let containerView = loadViewFromNib()
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(contentView)
        }
        self.contentView.frame = containerView.frame
        self.frame = containerView.frame
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setResource(resource: Codable) {
        let user = resource as! User
        self.user = user
        configure()
    }
    
    func configure() {
        let userClick = UserTapGestureRecognizer.init(target: self, action: #selector(userTapped))
        userBoxFullName.addGestureRecognizer(userClick)
        userBoxImage.addGestureRecognizer(userClick)
        contentView.addBorder(hexString: SettingsProvider.sharedInstance.getTheme(key: "borderBoxColor"), width: 0.2)
        contentView.addShadow(offset: CGSize.init(width: 0, height: 1), color: UIColor.init(hexString: SettingsProvider.sharedInstance.getTheme(key: "borderBoxColor")), radius: 5, opacity: 0.35)
        userBoxImage.kf.setImage(with: URL(string: user.imageURL!))
        userBoxImage.makeRounded()
        userBoxLevelIcon.kf.setImage(with: URL(string: (user.level?.iconURL)!))
        userBoxLevel.text = UtilsProvider.getLocalizedString(textKey: "user_box_level") + " \(user.level?.id ?? 0)"
        userBoxFullName.text = user.fullName
    }
    
    func getHeight() -> CGFloat {
        return self.frame.height
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
    
    @objc func userTapped(recognizer: UserTapGestureRecognizer) {
        NotificationCenter.default.post(name: .triggerGoToProfile, object: nil, userInfo: ["slug": recognizer.userSlug ?? ""])
    }
}
