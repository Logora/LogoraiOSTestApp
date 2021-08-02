import UIKit
import SnapKit

class NotificationBox: UITableViewCell, CellElement {
    let router = Router.sharedInstance
    let apiClient = APIClient.sharedInstance
    private var notification: UserNotification!
    private var notificationContainer: UIView! = UIView()
    private var notificationDate: UILabel! = UILabel()
    private var notificationImage: UIImageView! = UIImageView()
    private var content: UILabel! = UILabel()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        notificationImage.makeRounded()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        notificationImage.makeRounded()
    }
    
    func setResource(resource: Codable) {
        let notification = resource as! UserNotification
        self.notification = notification
        configure()
    }
    
    func configure() {
        self.initLayout()
        if (notification.isOpened == false) {
            notificationContainer.backgroundColor = UIColor.init(hexString: SettingsProvider.sharedInstance.textTertiary)
            notificationImage.backgroundColor = UIColor.init(hexString: SettingsProvider.sharedInstance.textTertiary)
            notificationDate.backgroundColor = UIColor.init(hexString: SettingsProvider.sharedInstance.textTertiary)
            content.backgroundColor = UIColor.init(hexString: SettingsProvider.sharedInstance.textTertiary)
        }
        notificationDate.text = notification.createdAt
        switch(notification.notifyType) {
            case "get_badge":
                let secondTarget = notification.secondTarget as! Badge
                notificationImage.kf.setImage(with: URL(string: secondTarget.iconURL))
                content.setRegularAndBoldText(regularText: "Vous avez obtenu le badge ", boldText: "\(secondTarget.title)")
                self.setOnClickListener(action: goToProfile, clickedObject: notification.redirectUrl)
                break;
            case "group_reply":
                let secondTarget = notification.secondTarget as! Debate
                if(notification.actorCount != nil && notification.actorCount! > 1) {
                    content.setRegularAndBoldText(regularText: "\(notification.actor.fullName!) et \(notification.actorCount! - 1) autres personnes ont répondu a votre message dans le débat ", boldText: "\(secondTarget.name!)")
                } else {
                    content.setRegularAndBoldText(regularText: "\(notification.actor.fullName!) à répondu a votre message dans le débat ", boldText: "\(secondTarget.name!)")
                }
                notificationImage.kf.setImage(with: URL(string: notification.actor.imageURL!))
                self.setOnClickListener(action: goToDebate, clickedObject: secondTarget.slug!)
                break;
            case "level_unlock":
                let target = notification.target as! User
                content.setRegularAndBoldText(regularText: "Vous êtes maintenant au niveau ", boldText: "\(target.level!.name!)")
                notificationImage.kf.setImage(with: URL(string: target.level!.iconURL))
                self.setOnClickListener(action: goToProfile, clickedObject: target.slug)
                break;
            case "get_vote":
                if(notification.actorCount != nil && notification.actorCount! > 1) {
                    content.text = "\(notification.actor.fullName!) et \(notification.actorCount! - 1) soutiennent votre argument"
                } else {
                    content.text = "\(notification.actor.fullName!) soutient votre argument"
                }
                notificationImage.kf.setImage(with: URL(string: notification.actor.imageURL!))
                self.setOnClickListener(action: goToDebate, clickedObject: notification.redirectUrl)
                break;
            case "group_follow_argument":
                let secondTarget = notification.secondTarget as! Debate
                if(notification.actorCount != nil && notification.actorCount! > 1) {
                    content.setRegularAndBoldText(regularText: "\(notification.actor.fullName!) et \(notification.actorCount! - 1) ont participé dans le débat ", boldText: "\(secondTarget.name!)")
                } else {
                    content.setRegularAndBoldText(regularText: "\(notification.actor.fullName!) a participé dans le débat ", boldText: "\(secondTarget.name!)")
                }
                notificationImage.kf.setImage(with: URL(string: notification.actor.imageURL!))
                self.setOnClickListener(action: goToDebate, clickedObject: secondTarget.slug)
                break;
            case "user_follow_level_unlock":
                content.setRegularAndBoldText(regularText: "\(notification.actor.fullName!) a atteint le niveau", boldText: "\(notification.actor.level!.name!)")
                self.setOnClickListener(action: goToProfile, clickedObject: notification.actor.slug)
                break;
            case "followed":
                content.text = "\(notification.actor.fullName!) vous a suivi."
                notificationImage.kf.setImage(with: URL(string: notification.actor.imageURL!))
                self.setOnClickListener(action: goToProfile, clickedObject: notification.actor.slug)
                break;
            case "group_invitation_new":
                return
            default:
                return
        }
    }
    
    func initLayout() {
        self.addSubview(notificationContainer)
        notificationContainer.addSubview(notificationImage)
        notificationContainer.addSubview(content)
        notificationContainer.addSubview(notificationDate)

        
        self.notificationContainer.addBorder(hexString: SettingsProvider.sharedInstance.getTheme(key: "borderBoxColor"), width: 0.2)
        self.notificationContainer.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self)
        }
        
        notificationImage.makeRounded()
        notificationImage.snp.makeConstraints { (make) in
            make.top.equalTo(self.notificationContainer).offset(15)
            make.bottom.equalTo(self.notificationContainer).offset(-15)
            make.left.equalTo(self).offset(15)
            make.height.width.equalTo(60)
        }

        content.numberOfLines = 0
        content.snp.makeConstraints { (make) in
            make.top.equalTo(self.notificationImage)
            make.left.equalTo(self.notificationImage.snp.right).offset(15)
        }

        notificationDate.setToSecondaryTextColor()
        notificationDate.setToTertiaryText()
        notificationDate.snp.makeConstraints { (make) in
            make.top.equalTo(self.content.snp.bottom).offset(5)
            make.left.equalTo(self.notificationImage.snp.right).offset(15)
        }
    }
    
    func getHeight() -> CGFloat {
        return self.frame.height
    }
    
    func goToProfile(clickedObject: Any?) {
        let slug = clickedObject as! String
        apiClient.readNotification(notificationId: self.notification.id, completion: { _ in
            self.router.setRoute(routeName: "USER", routeParam: slug)
        })
    }
    
    func goToDebate(clickedObject: Any?) {
        let slug = clickedObject as! String
        apiClient.readNotification(notificationId: self.notification.id, completion: { _ in
            self.router.setRoute(routeName: "DEBATE", routeParam: slug)
        })
    }
}
