import UIKit
import Kingfisher
import SnapKit

class ProfileViewController: UIViewController {
    private var userSlug: String?
    let apiClient = APIClient.sharedInstance
    
    lazy var userNameLabel: UILabel! = UILabel()
    lazy var userPicture: UIImageView! = UIImageView()
    lazy var debateCountLabel: UILabel! = UILabel()
    lazy var votesCountLabel: UILabel! = UILabel()
    lazy var followersCountLabel: UILabel! = UILabel()
    lazy var userBoxContainer: UIView! = UIView()
    lazy var userBoxLevelName: UILabel! = UILabel()
    lazy var userBoxLevelIcon: UIImageView! = UIImageView()
    
//    // Tab buttons
//    lazy var argumentsTabButton: UIButton!
//    lazy var argumentsTabButtonUnderline: UIView!
//    lazy var followersTabButton: UIButton!
//    lazy var followersTabButtonUnderline: UIView!
//    lazy var followingsTabButton: UIButton!
//    lazy var followingsTabButtonUnderline: UIView!
    
    public init(userSlug: String) {
        self.userSlug = userSlug
        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder aDecoder: NSCoder) {
        self.userSlug = ""
        super.init(coder: aDecoder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initLayout()
//        let child = SpinnerViewController()
//        DispatchQueue.main.async { // Loading animation on main thread
//            self.addChild(child)
//            child.view.frame = self.view.frame
//            self.view.addSubview(child.view)
//            child.didMove(toParent: self)
//        }
//        self.apiClient.getUser(slug: userSlug!, completion: { user in
//            DispatchQueue.main.async { // End loading animation when data is loaded
//                self.initLayout(user: user)
//                child.willMove(toParent: nil)
//                child.view.removeFromSuperview()
//                child.removeFromParent()
//            }
//        }, error: { error in
//            print(error)
//        })
    }
    
    func initLayout() {
        view.addSubview(userBoxContainer)
        userBoxContainer.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().offset(6)
            make.left.equalToSuperview()
        }
        userBoxContainer.layer.borderWidth = 0.2
        userBoxContainer.layer.borderColor = UIColor.init(hexString: SettingsProvider.sharedInstance.getTheme(key: "borderBoxColor")).cgColor
        userBoxContainer.layer.cornerRadius = 6
//        userBoxLevelName.text = "Niveau \(user.level?.id ?? 0)"
//        userBoxLevelIcon.kf.setImage(with: URL(string: (user.level?.iconURL)!))
//        userNameLabel.text = user.fullName
//        userNameLabel.font = UIFont.boldSystemFont(ofSize: userNameLabel.font.pointSize)
//        debateCountLabel.font = UIFont.boldSystemFont(ofSize: debateCountLabel.font.pointSize)
//        debateCountLabel.text = String(user.debatesCount ?? 0)
//        votesCountLabel.font = UIFont.boldSystemFont(ofSize: votesCountLabel.font.pointSize)
//        votesCountLabel.text = String(user.debatesVotesCount ?? 0)
//        followersCountLabel.font = UIFont.boldSystemFont(ofSize: followersCountLabel.font.pointSize)
//        followersCountLabel.text = String(user.followersCount ?? 0)
//        userPicture.makeRounded()
//        userPicture.kf.setImage(with: URL(string: (user.imageURL)!))
    }
}


