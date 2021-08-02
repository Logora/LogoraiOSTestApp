import UIKit
import SnapKit

class SearchInput: UIView {
    private final var router = Router.sharedInstance
    private var goBackIcon = UIImageView()
    private var searchIcon = UIImageView()
    private var searchInput = UITextField()
    
    weak var listener: NavbarContainerSwitcherListener? = nil
    
    required init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    func setup() {
        if #available(iOS 13.0, *) {
            self.goBackIcon.image = UIImage(named: "arrow-left", in: Bundle(for: type(of: self)), with: nil)
            self.searchIcon.image = UIImage(named: "search", in: Bundle(for: type(of: self)), with: nil)
        } else {
            // Fallback on earlier versions
        }
        
        self.addSubview(goBackIcon)
        self.addSubview(searchInput)
        self.addSubview(searchIcon)
        
        self.snp.makeConstraints{ (make) -> Void in
            make.height.equalTo(60)
            make.left.right.equalTo(self)
            make.centerY.equalTo(self)
        }
        
        self.goBackIcon.isUserInteractionEnabled = true
        self.goBackIcon.snp.makeConstraints{ (make) -> Void in
            make.left.equalTo(self).inset(10).priority(.required)
            make.width.height.equalTo(20)
            make.centerY.equalTo(self)
        }
        
        self.searchInput.becomeFirstResponder()
        self.searchInput.snp.makeConstraints{ (make) -> Void in
            make.left.equalTo(self.goBackIcon.snp.right).offset(15)
            make.right.equalTo(self.searchIcon.snp.left).offset(-15)
            make.centerY.equalTo(self)
        }
        
        self.searchIcon.isUserInteractionEnabled = true
        self.searchIcon.snp.makeConstraints{ (make) -> Void in
            make.right.equalTo(self).inset(10).priority(.required)
            make.width.height.equalTo(20)
            make.centerY.equalTo(self)
        }
        
        initActions()
    }
    
    func initActions() {
        searchIcon.setOnClickListener(action: initSearch)
        goBackIcon.setOnClickListener(action: goBackToNavbar)
    }
    
    func initSearch(clickedObject: Any?) {
        router.setRoute(routeName: "SEARCH", routeParam: self.searchInput.text!)
        listener?.resetNavbar()
        self.searchInput.text = ""
    }
    
    func goBackToNavbar(clickedObject: Any?) {
        self.searchInput.text = ""
        listener?.resetNavbar()
    }
}

@objc protocol NavbarContainerSwitcherListener: AnyObject {
    func resetNavbar()
}
