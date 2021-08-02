import UIKit
import SnapKit

class NextBadgeBox: UITableViewCell, CellElement {
    private var nextBadge: NextBadge!
    private var nextBadgeContainer: UIView! = UIView()
    private var nextBadgeName: UILabel! = UILabel()
    private var nextBadgeDescription: UILabel! = UILabel()
    private var nextBadgeImage: UIImageView! =  UIImageView()
    private var nextBadgeProgress: UIProgressView! = UIProgressView()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    func setResource(resource: Codable) {
        let nextBadge = resource as! NextBadge
        self.nextBadge = nextBadge
        configure()
    }
    
    func configure() {
        let nextBadgeNameContainer = UIView()
        self.addSubview(nextBadgeContainer)
        nextBadgeContainer.addSubview(nextBadgeImage)
        nextBadgeContainer.addSubview(nextBadgeNameContainer)
        nextBadgeNameContainer.addSubview(nextBadgeName)
        nextBadgeNameContainer.addSubview(nextBadgeDescription)
        nextBadgeNameContainer.addSubview(nextBadgeProgress)
        
        self.nextBadgeContainer.addBorder(hexString: SettingsProvider.sharedInstance.getTheme(key: "borderBoxColor"), width: 0.2)
        self.nextBadgeContainer.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self)
        }
        
        nextBadgeImage.kf.setImage(with: URL(string: nextBadge.badge.iconURL))
        nextBadgeImage.makeRounded()
        nextBadgeImage.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-15)
            make.top.equalTo(self.nextBadgeContainer).offset(15)
            make.bottom.equalTo(self.nextBadgeContainer).offset(-15)
            make.height.width.equalTo(60)
        }
    
        nextBadgeNameContainer.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.nextBadgeImage.snp.centerY)
            make.top.equalTo(self.nextBadgeName.snp.top)
            make.bottom.equalTo(self.nextBadgeProgress.snp.bottom)
            make.left.equalTo(self.nextBadgeContainer).offset(15)
            make.right.equalTo(self.nextBadgeImage.snp.left).offset(-15)
        }
        
        nextBadgeName.text = nextBadge.badge.title
        nextBadgeName.setToBold()
        nextBadgeName.snp.makeConstraints { (make) in
            make.top.left.equalTo(nextBadgeNameContainer)
        }
        
        nextBadgeDescription.text = nextBadge.badge.description
        nextBadgeDescription.setToSecondaryText()
        nextBadgeDescription.snp.makeConstraints { (make) in
            make.top.equalTo(self.nextBadgeName.snp.bottom).offset(5)
            make.left.equalTo(nextBadgeNameContainer)
        }
        
        nextBadgeProgress.layer.cornerRadius = 15
        nextBadgeProgress.clipsToBounds = true
        nextBadgeProgress.layer.sublayers![1].cornerRadius = 15
        nextBadgeProgress.subviews[1].clipsToBounds = true
        nextBadgeProgress.progress = 0
        nextBadgeProgress.snp.makeConstraints { (make) in
            make.top.equalTo(self.nextBadgeDescription.snp.bottom).offset(5)
            make.left.right.equalTo(nextBadgeNameContainer)
            make.height.equalTo(30)
        }
    }
    
    func getHeight() -> CGFloat {
        return self.frame.height
    }
}
