import UIKit
import SnapKit

class Navbar: UIView, NavbarContainerSwitcherListener, AuthChangeListener {
    let authService = AuthService.sharedInstance
    let router = Router.sharedInstance
    
    lazy var containerView: UIView = UIView()
    
    lazy var indexButton: IconTextView! = IconTextView(svgName: "home", textKey: "infoAllDebatesShort")
    lazy var searchButton: IconTextView! = IconTextView(svgName: "search", textKey: "search")
    lazy var notificationButton: IconTextView! = IconTextView(svgName: "alarm", textKey: "notifications")
    lazy var profileButton: IconTextView! = IconTextView(svgName: "login", textKey: "actionSignIn")
    
    lazy var searchContainer = SearchInput()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        authService.listener = self
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        authService.listener = self
        setup()
    }
    
    func authChanged(success: Bool) {
        DispatchQueue.main.async {
            self.setup()
            if success == true {
                self.profileButton.replaceImage(imageUrl: (self.authService.currentUser?.imageURL)!, textKey: "user_profile")
            }
        }
    }
    
    func setup() {
        searchContainer.listener = self
        
        self.addSubview(self.containerView)
        self.containerView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self).inset(UIEdgeInsets(top: 0, left: -5, bottom: 0, right: -5))
        }
        
        self.containerView.addBorder(hexString: SettingsProvider.sharedInstance.getTheme(key: "borderBoxColor"), width: 0.2)
        self.containerView.addShadow(offset: CGSize.init(width: 0, height: 1), color: UIColor.init(hexString: SettingsProvider.sharedInstance.getTheme(key: "borderBoxColor")), radius: 5, opacity: 0.35)
        
        self.addSubview(self.indexButton)
        self.addSubview(self.searchButton)
        if (authService.getLoggedIn() == true) {
            
            self.addSubview(self.notificationButton)
        }
        self.addSubview(self.profileButton)
        self.indexButton.snp.makeConstraints { (make) -> Void in
            make.top.bottom.equalTo(self).inset(10)
            make.centerY.equalTo(self)
            make.left.equalTo(self).inset(10)
        }
        
        if (authService.getLoggedIn() == true) {
            self.notificationButton.snp.makeConstraints { (make) -> Void in
                make.top.bottom.equalTo(self).inset(10)
                make.centerY.equalTo(self)
                make.right.equalTo(self.searchButton.snp.left).offset(-15)
            }
        }
        
        self.searchButton.snp.makeConstraints { (make) -> Void in
            make.top.bottom.equalTo(self).inset(10)
            make.centerY.equalTo(self)
            make.right.equalTo(self.profileButton.snp.left).offset(-15)
        }
        
        self.profileButton.snp.makeConstraints { (make) -> Void in
            make.top.bottom.equalTo(self).inset(10)
            make.centerY.equalTo(self)
            make.left.equalTo(self.searchButton.snp.right).offset(15)
            make.right.equalTo(self).inset(10)
        }
        initActions()
    }
    
    func initActions() {
        indexButton.setOnClickListener(action: goToIndex)
        searchButton.setOnClickListener(action: initSearch)
        notificationButton.setOnClickListener(action: goToNotification)
        profileButton.setOnClickListener(action: goToProfile)
    }
    
    func goToIndex(clickedObject: Any?) {
        router.setRoute(routeName: "INDEX", routeParam: "")
    }
    
    func initSearch(clickedObject: Any?) {
        toggleSearchContainer(isActive: true)
    }
    
    func goToNotification(clickedObject: Any?) {
        router.setRoute(routeName: "NOTIFICATION", routeParam: "")
    }
    
    func goToProfile(clickedObject: Any?) {
        if (authService.getLoggedIn() == true) {
            router.setRoute(routeName: "USER", routeParam: "\(authService.getCurrentUser().slug!)")
        } else {
            let modalView = SideModal()
            let modalViewController = ModalViewController(modalView: modalView, modalHeight: 150, modalWidth: 300)
            self.parentViewController!.present(modalViewController, animated: true, completion: nil)
        }
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
    
    func toggleSearchContainer(isActive: Bool) {
        switch(isActive) {
        case true:
            self.indexButton.removeFromSuperview()
            self.searchButton.removeFromSuperview()
            self.notificationButton.removeFromSuperview()
            self.profileButton.removeFromSuperview()
            self.addSubview(searchContainer)
            self.searchContainer.snp.makeConstraints { (make) -> Void in
                make.top.bottom.left.right.equalTo(self)
                make.centerY.equalTo(self)
            }
        case false:
            self.searchContainer.removeFromSuperview()
            setup()
        }
    }
    
    func resetNavbar() {
        toggleSearchContainer(isActive: false)
    }
}
