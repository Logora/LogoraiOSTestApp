import UIKit
import SnapKit

public class LogoraApp: UIViewController, RouteChangeListener  {
    let authService = AuthService.sharedInstance
    let apiClient = APIClient.sharedInstance
    let router = Router.sharedInstance
    let utilsProvider = UtilsProvider.sharedInstance
    public var applicationName: String
    public var authAssertion: String
    public var routeName: String? = "INDEX"
    public var routeParam: String?
    private var loaderViewController: SpinnerViewController! = SpinnerViewController()

    lazy var navbarView: Navbar! = Navbar()
    lazy var scrollView: UIScrollView! = UIScrollView()
    lazy var contentView: UIView! = UIView()
    lazy var containerView: UIView! = UIView()
    lazy var footerView: Footer! = Footer()

    public init(applicationName: String, authAssertion: String, routeName: String? = "INDEX", routeParam: String? = "") {
        self.applicationName = applicationName
        self.authAssertion = authAssertion
        self.routeName = routeName
        self.routeParam = routeParam
        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder aDecoder: NSCoder) {
        self.applicationName = ""
        self.authAssertion = ""
        self.routeName = ""
        self.routeParam = ""
        super.init(coder: aDecoder)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        router.listener = self
        
        apiClient.applicationName = self.applicationName
        apiClient.authAssertion = self.authAssertion
        
        DispatchQueue.main.async {
            self.utilsProvider.showLoader(currentVC: self)
        }
    }
    
    public override func viewSafeAreaInsetsDidChange() {
        self.initLayout()
        
        SettingsProvider.sharedInstance.getSettings(completion: {
            self.authService.authenticate(completion: {
                DispatchQueue.main.async {
                    self.routeChanged(routeName: self.routeName!, routeParam: self.routeParam!)
                }
            })
        })
    }

    func addChildViewController(asChildViewController viewController: UIViewController) {
        self.addChild(viewController)

        let childView = viewController.view!
        self.containerView.addSubview(childView)
        childView.translatesAutoresizingMaskIntoConstraints = false
        childView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self.containerView)
        }
        viewController.didMove(toParent: self)
    }

    public func removeChildViewController() {
        if self.children.count > 0 {
            let viewControllers:[UIViewController] = self.children
            viewControllers.last?.willMove(toParent: nil)
            viewControllers.last?.removeFromParent()
            viewControllers.last?.view.removeFromSuperview()
        }
     }

    public func initLayout() {
        self.view.addSubview(navbarView)
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.contentView)
        self.contentView.addSubview(self.containerView)
        self.contentView.addSubview(self.footerView)
        
        self.navbarView.translatesAutoresizingMaskIntoConstraints = false
        self.navbarView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.view).offset(safeAreaTop)
            make.left.right.leading.trailing.equalTo(self.view)
        }
        self.navbarView.backgroundColor = UIColor.white

        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.navbarView.snp.bottom)
            make.left.right.leading.trailing.bottom.equalTo(self.view)
        }
        self.scrollView.backgroundColor = UIColor.white

        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.scrollView)
            make.width.equalTo(self.scrollView)
        }
        self.contentView.backgroundColor = UIColor.white
        
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
        self.containerView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(contentView).offset(10)
            make.bottom.equalTo(footerView.snp.top)
            make.left.equalTo(contentView).offset(10)
            make.right.equalTo(contentView).offset(-10)
        }
        self.containerView.backgroundColor = UIColor.white

        footerView.translatesAutoresizingMaskIntoConstraints = false
        footerView.snp.makeConstraints { (make) -> Void in
            make.left.right.leading.trailing.equalToSuperview()
            make.top.equalTo(containerView.snp.bottom)
            make.bottom.equalToSuperview()
            make.height.equalTo(200)
        }
        self.footerView.backgroundColor = UIColor.white
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    func routeChanged(routeName: String, routeParam: String) {
        DispatchQueue.main.async {
            self.removeChildViewController()
            switch routeName {
                case "DEBATE":
                    self.addChildViewController(asChildViewController: DebateViewController(debateSlug: routeParam))
                case "USER":
                    self.addChildViewController(asChildViewController: UserViewController(userSlug: "glkejlgkj-lkjdlkjflkj"))
                case "INDEX":
                    self.addChildViewController(asChildViewController: IndexViewController())
                case "SEARCH":
                    self.addChildViewController(asChildViewController: SearchViewController(searchQuery: routeParam))
                case "NOTIFICATION":
                    self.addChildViewController(asChildViewController: NotificationViewController())
                default:
                    self.addChildViewController(asChildViewController: IndexViewController())
            }
        }
    }
}
