import UIKit
import SnapKit

class NotificationViewController: UIViewController {
    let apiClient = APIClient.sharedInstance
    lazy var notificationListHeader: UILabel! = UILabel()
    lazy var notificationList: UIView! = UIView()
    lazy var readAllNotificationButton: UILabel! = UILabel()

    public init() {
        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        let notificationListViewController = PaginatedTableViewController<UserNotification, NotificationBox>(resourcePath: "notifications", perPage: 5)
        addChild(notificationListViewController)
        self.notificationList = notificationListViewController.view
        
        initLayout()
    }

    public func initLayout() {
        self.view.addSubview(notificationListHeader)
        self.view.addSubview(readAllNotificationButton)
        self.view.addSubview(notificationList)
        
        self.view.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self.view)
            make.bottom.equalTo(notificationList.snp.bottom)
        }
        
        self.notificationListHeader.text = UtilsProvider.getLocalizedString(textKey: "notifications")
        self.notificationListHeader.snp.makeConstraints { (make) in
            make.left.equalTo(self.view)
            make.top.equalTo(self.view)
        }
        
        self.readAllNotificationButton.isUserInteractionEnabled = true
        self.readAllNotificationButton.text = UtilsProvider.getLocalizedString(textKey: "notifications_read_all")
        self.readAllNotificationButton.textColor = UIColor.init(hexString: SettingsProvider.sharedInstance.get(key: "theme.callPrimaryColor"))
        self.readAllNotificationButton.setOnClickListener(action: readAllNotifications, clickedObject: nil)
        self.readAllNotificationButton.snp.makeConstraints { (make) in
            make.right.equalTo(self.view)
            make.top.equalTo(self.view)
        }
        
        self.notificationList.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(self.notificationListHeader.snp.bottom).offset(15)
        }
    }
    
    func readAllNotifications(clickedObject: Any?) {
        apiClient.readAllNotification(completion: { _ in
            DispatchQueue.main.async {
                Toast.show(message: UtilsProvider.getLocalizedString(textKey: "notifications_read_all_success"), controller: self)
                self.initLayout()
            }
        })
    }
}
