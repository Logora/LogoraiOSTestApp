import UIKit
import SnapKit

class BadgeBox: UITableViewCell, CellElement {
    private var badge: Badge!
    private var badgeContainer: UIView! = UIView()
    private var badgeName: UILabel! = UILabel()
    private var badgeDescription: UILabel! = UILabel()
    private var badgeImage: UIImageView! =  UIImageView()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    func setResource(resource: Codable) {
        let badge = resource as! Badge
        self.badge = badge
        configure()
    }
    
    func configure() {
        let badgeNameContainer = UIView()
        self.addSubview(badgeContainer)
        badgeContainer.addSubview(badgeImage)
        badgeContainer.addSubview(badgeNameContainer)
        badgeNameContainer.addSubview(badgeName)
        badgeNameContainer.addSubview(badgeDescription)
        
        self.badgeContainer.addBorder(hexString: SettingsProvider.sharedInstance.getTheme(key: "borderBoxColor"), width: 0.2)
        self.badgeContainer.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self)
        }
        
        badgeImage.kf.setImage(with: URL(string: badge.iconURL))
        badgeImage.makeRounded()
        badgeImage.snp.makeConstraints { (make) in
            make.top.equalTo(self.badgeContainer).offset(15)
            make.bottom.equalTo(self.badgeContainer).offset(-15)
            make.left.equalTo(self).offset(15)
            make.height.width.equalTo(60)
        }
        
        badgeNameContainer.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.badgeImage.snp.centerY)
            make.top.equalTo(self.badgeName.snp.top)
            make.bottom.equalTo(self.badgeDescription.snp.bottom)
            make.left.equalTo(self.badgeImage.snp.right).offset(10)
        }
        
        badgeName.text = badge.title
        badgeName.setToBold()
        badgeName.snp.makeConstraints { (make) in
            make.top.left.equalTo(badgeNameContainer)
        }
        
        badgeDescription.text = badge.description
        badgeDescription.setToSecondaryText()
        badgeDescription.snp.makeConstraints { (make) in
            make.top.equalTo(self.badgeName.snp.bottom).offset(5)
            make.left.equalTo(badgeNameContainer)
        }
    }
    
    func getHeight() -> CGFloat {
        return self.frame.height
    }
}
