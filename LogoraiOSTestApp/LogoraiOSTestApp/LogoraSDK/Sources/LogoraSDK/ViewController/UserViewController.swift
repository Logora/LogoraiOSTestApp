import UIKit

class UserViewController: UIViewController {
    let apiClient = APIClient.sharedInstance
    let utilsProvider = UtilsProvider.sharedInstance

    private var userSlug: String
    private var user: User?
    private var currentTab: Int = 0
    private var loaderViewController: SpinnerViewController! = SpinnerViewController()

    lazy var userNameLabel: UILabel! = UILabel()
    lazy var userPicture: UIImageView! = UIImageView()
    lazy var debatesCountLabel: UILabel! = UILabel()
    lazy var votesCountLabel: UILabel! = UILabel()
    lazy var followersCountLabel: UILabel! = UILabel()
    lazy var userBoxContainer: UIView! = UIView()
    lazy var userInterestsLabel: UILabel! = UILabel()
    lazy var interestsPlaceholder: UILabel! = UILabel()
    lazy var userStatsStackView: UIView! = UIView()
    lazy var currentBadgesLabel: UILabel! = UILabel()
    lazy var nextBadgesLabel: UILabel! = UILabel()
    
    lazy var userContentList: UIView! = UIView()
    
    private var argumentListViewController: UIViewController?
    private var nextBadgeListViewController: PaginatedTableViewController<NextBadge, NextBadgeBox>?
    private var badgeListViewController: UIViewController?
    private var followerListViewController: UIViewController?
    private var followingListViewController: UIViewController?
    private var tabs: Tab?

    override func viewDidLoad() {
        super.viewDidLoad()
        argumentListViewController = PaginatedTableViewController<Message, ArgumentBox>(resourcePath: "users/" + self.userSlug + "/messages")
        nextBadgeListViewController = PaginatedTableViewController<NextBadge, NextBadgeBox>(resourcePath: "users/" + self.userSlug + "/next_badges", perPage: 2, hasLoader: false)
        badgeListViewController = PaginatedTableViewController<Badge, BadgeBox>(resourcePath: "users/" + self.userSlug + "/current_badges")
        followerListViewController = PaginatedTableViewController<User, UserBoxView>(resourcePath: "users/" + self.userSlug + "/disciples")
        followingListViewController = PaginatedTableViewController<User, UserBoxView>(resourcePath: "users/" + self.userSlug + "/mentors")
        tabs = Tab(textKeys: ["Arguments", "Badges", "Disciples", "Mentors"], callbackFunc: useTabs)
        DispatchQueue.main.async {
            self.utilsProvider.showLoader(currentVC: self)
        }
        self.apiClient.getUser(slug: userSlug, completion: { user in
            DispatchQueue.main.async {
                self.user = user
                self.initLayout()
                self.initUserStats()
                self.initInterests()
                self.utilsProvider.hideLoader()
            }
        }, error: { error in
            print(error)
        })
        setTab(tabIndex: 0)
    }

    public init(userSlug: String) {
        self.userSlug = userSlug
        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder aDecoder: NSCoder) {
        self.userSlug = ""
        super.init(coder: aDecoder)
    }
    
    func initLayout() {
        let userStackView = UIView()
        self.view.addSubview(userBoxContainer)
        self.view.addSubview(userStackView)
        self.view.addSubview(userStatsStackView)
        self.view.addSubview(userInterestsLabel)
        self.view.addSubview(interestsPlaceholder)
        self.view.addSubview(tabs!)
        self.view.addSubview(self.userContentList)
        
        self.userBoxContainer.addBorder(hexString: SettingsProvider.sharedInstance.getTheme(key: "borderBoxColor"), width: 0.2)
        self.userBoxContainer.addShadow(offset: CGSize.init(width: 0, height: 1), color: UIColor.init(hexString: SettingsProvider.sharedInstance.getTheme(key: "borderBoxColor")), radius: 5, opacity: 0.35)
        self.userBoxContainer.snp.makeConstraints { (make) -> Void in
            make.top.left.right.equalTo(self.view)
            make.bottom.equalTo(self.interestsPlaceholder.snp.bottom).offset(15)
        }
        
        userStackView.addSubview(userPicture)
        userStackView.addSubview(userNameLabel)
        userStackView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(userBoxContainer).offset(15)
            make.centerX.equalTo(userBoxContainer.snp.centerX)
        }
        
        userPicture.kf.setImage(with: URL(string: (user?.imageURL)!))
        userPicture.makeRounded()
        self.userPicture.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(userStackView)
            make.left.equalTo(userStackView.snp.left)
            make.width.equalTo(80)
            make.height.equalTo(80)
        }

        userNameLabel.text = user?.fullName!
        userNameLabel.setToSubtitle()
        userNameLabel.setToBold()
        self.userNameLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(userStackView)
            make.right.equalTo(userStackView.snp.right)
            make.centerY.equalTo(self.userPicture.snp.centerY)
            make.left.equalTo(userPicture.snp.right).offset(5)
        }
        
        tabs!.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(userBoxContainer.snp.bottom).offset(15)
            make.left.right.equalToSuperview()
        }

        self.userContentList.snp.makeConstraints { (make) in
            make.top.equalTo(tabs!.snp.bottom).offset(15)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func initUserStats() {
        let userDebatesCount = UILabel()
        userStatsStackView.addSubview(userDebatesCount)
        userStatsStackView.addSubview(debatesCountLabel)
        let userVotesCount = UILabel()
        userStatsStackView.addSubview(userVotesCount)
        userStatsStackView.addSubview(votesCountLabel)
        let userFollowersCount = UILabel()
        userStatsStackView.addSubview(userFollowersCount)
        userStatsStackView.addSubview(followersCountLabel)
        
        userStatsStackView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(userPicture.snp.bottom).offset(15)
            make.centerX.equalTo(userBoxContainer.snp.centerX)
        }
        
        debatesCountLabel.text = UtilsProvider.getLocalizedString(textKey: "user_debates_count_text")
        debatesCountLabel.setToSecondaryTextColor()
        userDebatesCount.text = "\(user?.debatesCount ?? 0)"
        userDebatesCount.setToBold()
        userDebatesCount.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(userPicture.snp.bottom).offset(15)
            make.left.equalTo(userStatsStackView.snp.left)
            make.width.equalTo(debatesCountLabel.intrinsicContentSize.width)
        }
        
        debatesCountLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(userDebatesCount.snp.bottom).offset(5)
            make.left.equalTo(userDebatesCount.snp.left)
        }
        
        votesCountLabel.text = UtilsProvider.getLocalizedString(textKey: "user_votes_count_text")
        votesCountLabel.setToSecondaryTextColor()
        userVotesCount.text = "\(user?.debatesVotesCount ?? 0)"
        userVotesCount.setToBold()
        userVotesCount.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(userPicture.snp.bottom).offset(15)
            make.left.equalTo(debatesCountLabel.snp.right).offset(15)
            make.width.equalTo(votesCountLabel.intrinsicContentSize.width)
        }
        
        votesCountLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(userVotesCount.snp.bottom).offset(5)
            make.left.equalTo(userVotesCount.snp.left)
        }
        
        followersCountLabel.text = UtilsProvider.getLocalizedString(textKey: "user_disciples_count_text")
        followersCountLabel.setToSecondaryTextColor()
        userFollowersCount.text = "\(user?.followersCount ?? 0)"
        userFollowersCount.setToBold()
        userFollowersCount.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(userPicture.snp.bottom).offset(15)
            make.left.equalTo(votesCountLabel.snp.right).offset(15)
            make.width.equalTo(followersCountLabel.intrinsicContentSize.width)
        }
        
        followersCountLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(userFollowersCount.snp.bottom).offset(5)
            make.left.equalTo(userFollowersCount.snp.left)
            make.right.equalTo(userStatsStackView.snp.right)
        }
    }
    
    func initInterests() {
        self.userInterestsLabel.text = UtilsProvider.getLocalizedString(textKey: "user_tags_header")
        self.userInterestsLabel.setToBold()
        self.interestsPlaceholder.text = UtilsProvider.getLocalizedString(textKey: "user_tags_empty")
        self.interestsPlaceholder.setToItalic()
        self.interestsPlaceholder.setToSecondaryTextColor()
        
        userInterestsLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(votesCountLabel.snp.bottom).offset(15)
            make.left.equalTo(debatesCountLabel.snp.left)
            make.right.equalTo(followersCountLabel.snp.right)
        }
        
        interestsPlaceholder.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(userInterestsLabel.snp.bottom).offset(5)
            make.left.equalTo(userInterestsLabel.snp.left)
        }
    }
    
    func useTabs(clickedObject: Any?) -> Void {
        let index = clickedObject as! Int
        switch(index) {
            case 0:
                if(self.currentTab != 0) {
                    setTab(tabIndex: 0)
                }
            case 1:
                if(self.currentTab != 1) {
                    setTab(tabIndex: 1)
                }
            case 2:
                if(self.currentTab != 2) {
                    setTab(tabIndex: 2)
                }
            case 3:
                if(self.currentTab != 3) {
                    setTab(tabIndex: 3)
                }
            default:
                return
        }
    }
    
    func setTab(tabIndex: Int) {
        if(tabIndex == 0) {
            removeTab()
            addChild(argumentListViewController!)
            userContentList.addSubview(argumentListViewController!.view)
            argumentListViewController!.view.frame = userContentList.bounds
            argumentListViewController!.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            argumentListViewController!.didMove(toParent: self)
            self.currentTab = 0
            tabs?.setActive(tabIndex: 0)
        } else if(tabIndex == 1) {
            removeTab()
            currentBadgesLabel.text = UtilsProvider.getLocalizedString(textKey: "user_badges_header")
            currentBadgesLabel.setToBold()
            currentBadgesLabel.setToSecondaryTextColor()
            nextBadgesLabel.text = UtilsProvider.getLocalizedString(textKey: "user_next_badges_header")
            nextBadgesLabel.setToBold()
            nextBadgesLabel.setToSecondaryTextColor()
            
            addChild(nextBadgeListViewController!)
            addChild(badgeListViewController!)
            userContentList.addSubview(nextBadgesLabel)
            userContentList.addSubview(currentBadgesLabel)
            userContentList.addSubview(nextBadgeListViewController!.view)
            userContentList.addSubview(badgeListViewController!.view)
            nextBadgeListViewController!.didMove(toParent: self)
            badgeListViewController!.didMove(toParent: self)
            nextBadgesLabel.snp.makeConstraints { (make) in
                make.top.equalTo(userContentList)
            }
            nextBadgeListViewController!.view.snp.makeConstraints { (make) in
                make.top.equalTo(nextBadgesLabel.snp.bottom).offset(15)
                make.left.right.equalTo(userContentList)
            }
            currentBadgesLabel.snp.makeConstraints { (make) in
                make.top.equalTo(nextBadgeListViewController!.view.snp.bottom).offset(15)
            }
            badgeListViewController!.view.snp.makeConstraints { (make) in
                make.top.equalTo(currentBadgesLabel.snp.bottom).offset(15)
                make.left.right.equalTo(userContentList)
            }
            self.currentTab = 1
            tabs?.setActive(tabIndex: 1)
        } else if(tabIndex == 2) {
            removeTab()
            addChild(followerListViewController!)
            userContentList.addSubview(followingListViewController!.view)
            followerListViewController!.view.frame = userContentList.bounds
            followerListViewController!.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            followerListViewController!.didMove(toParent: self)
            self.currentTab = 2
            tabs?.setActive(tabIndex: 2)
        } else if(tabIndex == 3) {
            removeTab()
            addChild(followingListViewController!)
            userContentList.addSubview(followingListViewController!.view)
            followingListViewController!.view.frame = userContentList.bounds
            followingListViewController!.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            followingListViewController!.didMove(toParent: self)
            self.currentTab = 3
            tabs?.setActive(tabIndex: 3)
        }
    }
    
    func removeTab() {
        currentBadgesLabel.removeFromSuperview()
        nextBadgesLabel.removeFromSuperview()
        if self.children.count > 0 {
            self.children.forEach { VC in
                VC.willMove(toParent: nil)
                VC.removeFromParent()
                VC.view.removeFromSuperview()
            }
        }
     }
}
