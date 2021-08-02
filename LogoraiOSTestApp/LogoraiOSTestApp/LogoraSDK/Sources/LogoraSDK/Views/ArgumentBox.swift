import UIKit
import SnapKit

class ArgumentBox: UITableViewCell, CellElement {
    private final var router = Router.sharedInstance
    private final var auth = AuthService.sharedInstance
    private var argument: Message!
    private var argumentContainer: UIView! = UIView()
    private var positionLabelContainer: UIView! = UIView()
    private var positionLabel: UILabel! = UILabel()
    private var argumentDate: UILabel! = UILabel()
    private var moderatedLabel: TextWithLink! = TextWithLink(hyperLink: "https://logora.fr/moderation", content: "Votre argument à" + "\n" + "été modéré," + "\n" + "Pour en savoir plus," + "\n" + "lisez notre" + "\n" + "charte de modération", clickableContent: "charte de modération", textType: "tertiary", textAlign: "right")
    private var argumentContent: UILabel! = UILabel()
    private var argumentBoxFooter: ArgumentBoxFooter! = ArgumentBoxFooter()
    private var argumentBoxReplies: ArgumentBoxReplies! = ArgumentBoxReplies()
    var authorBox: ArgumentAuthorBox! = ArgumentAuthorBox()
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    func setResource(resource: Codable) {
        let argument = resource as! Message
        self.argument = argument
        configure()
    }
    
    func configure() {
        self.authorBox.setup(isInput: false, author: argument.author, defaultAuthor: nil, isDefaultAuthor: false)
        self.argumentBoxFooter.setup(argument: self.argument)
        self.argumentBoxReplies.setup(argument: self.argument)
        self.addSubview(self.argumentContainer)
        self.addSubview(self.authorBox)
        self.addSubview(self.positionLabelContainer)
        self.addSubview(self.argumentDate)
        self.addSubview(self.argumentContent)
        self.addSubview(self.argumentBoxFooter)
        self.addSubview(self.argumentBoxReplies)
        
        
        self.argumentContainer.addBorder(hexString: SettingsProvider.sharedInstance.getTheme(key: "borderBoxColor"), width: 0.2)
        self.argumentContainer.snp.makeConstraints { (make) -> Void in
            make.top.right.left.equalTo(self)
            make.bottom.equalTo(self.argumentBoxFooter.snp.bottom).offset(15)
        }
        
        self.authorBox.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self).offset(15)
            make.left.equalTo(self).offset(15)
            make.right.equalTo(self).offset(-15)
        }
        
        initPositionLabel()
        
        self.argumentDate.text = argument.createdAt.toDate()?.timeAgoDisplay()
        self.argumentDate.setToTertiaryText()
        self.argumentDate.setToSecondaryTextColor()
        self.argumentDate.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.authorBox.snp.bottom)
            make.right.equalTo(self).offset(-5)
        }
        
        self.argumentContent.text = self.argument.content
        self.argumentContent.font = UIFont.systemFont(ofSize: 17.0)
        self.argumentContent.numberOfLines = 0
        self.argumentContent.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.authorBox.snp.bottom).offset(15)
            make.left.equalTo(self).offset(15)
            make.right.equalTo(self).offset(-15)
            make.bottom.equalTo(self.argumentBoxFooter.snp.top).offset(-15)
        }
        
        self.argumentBoxFooter.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.argumentContent.snp.bottom).offset(15)
            make.left.equalTo(self).offset(15)
            make.right.equalTo(self).offset(-15)
            make.bottom.equalTo(self).offset(-15)
        }
        
        if (self.argument.repliesAuthors != nil && self.argument.repliesAuthors!.count > 0) {
            self.argumentBoxReplies.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(self.argumentBoxFooter.snp.bottom).offset(15)
                make.left.equalTo(self).offset(15)
                make.right.equalTo(self).offset(-15)
                make.bottom.equalTo(self).offset(-15)
            }
            
            self.argumentBoxFooter.snp.remakeConstraints { (make) -> Void in
                make.top.equalTo(self.argumentContent.snp.bottom).offset(15)
                make.left.equalTo(self).offset(15)
                make.right.equalTo(self).offset(-15)
            }
        }
        
        if (self.argument.status != "accepted") {
            self.setToModerated()
        }
    }
    
    func getHeight() -> CGFloat {
        var height: CGFloat = 0
        for view in self.subviews {
            height = height + view.bounds.size.height
        }
        return height
    }
    
    func initPositionLabel() {
        let positionIndex = self.argument.group?.getPositionIndex(index: self.argument.position.id)
        if (positionIndex == 0) {
            self.positionLabel.text = self.argument.group?.groupContext.positions[positionIndex!].name
            self.positionLabelContainer.backgroundColor = UIColor.init(hexString: SettingsProvider.sharedInstance.get(key: "theme.forPrimaryColor"))
        } else {
            self.positionLabel.text = self.argument.group?.groupContext.positions[positionIndex!].name
            self.positionLabelContainer.backgroundColor = UIColor.init(hexString: SettingsProvider.sharedInstance.get(key: "theme.againstPrimaryColor"))
        }
        self.positionLabelContainer.roundCorners([.topRight, .bottomLeft], radius: 6)
        self.positionLabelContainer.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self)
            make.right.equalTo(self)
        }
        
        self.positionLabelContainer.addSubview(self.positionLabel)
        self.positionLabel.textColor = UIColor.white
        self.positionLabel.setToBold()
        self.positionLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.positionLabelContainer).offset(5)
            make.right.equalTo(self.positionLabelContainer).offset(-5)
            make.left.equalTo(self.positionLabelContainer).offset(5)
            make.bottom.equalTo(self.positionLabelContainer).offset(-5)
        }
    }
    
    func setToModerated() {
        self.authorBox.isOpaque = false
        self.authorBox.alpha = CGFloat(0.5)
        self.positionLabelContainer.isOpaque = false
        self.positionLabelContainer.alpha = CGFloat(0.5)
        self.argumentContent.isOpaque = false
        self.argumentContent.alpha = CGFloat(0.5)
        self.argumentBoxFooter.isOpaque = false
        self.argumentBoxFooter.alpha = CGFloat(0.5)
        self.argumentBoxReplies.isOpaque = false
        self.argumentBoxReplies.alpha = CGFloat(0.5)
        self.argumentDate.isHidden = true
        
        self.addSubview(moderatedLabel)
        self.moderatedLabel.isUserInteractionEnabled = true
        self.moderatedLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.positionLabelContainer.snp.bottom).offset(3)
            make.right.equalTo(self).offset(-3)
        }
        
        self.argumentContent.snp.remakeConstraints { (make) in
            make.top.equalTo(self.moderatedLabel.snp.bottom).offset(15)
            make.left.equalTo(self).offset(15)
            make.right.equalTo(self).offset(-15)
        }
    }
}
