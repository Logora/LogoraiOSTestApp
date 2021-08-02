import Foundation
import UIKit

class SearchViewController: UIViewController {
    private var searchQuery: String
    private var currentTab: Int = 0
    private var debateListViewController: UIViewController?
    private var userListViewController: UIViewController?

    lazy var header: UILabel! = UILabel()
    private var tabs: Tab?
    lazy var resultList: UIView! = UIView()

    public init(searchQuery: String) {
        self.searchQuery = searchQuery
        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder aDecoder: NSCoder) {
        self.searchQuery = ""
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        debateListViewController = PaginatedTableViewController<Debate, DebateBoxView>(resourcePath: "groups", perPage: 4, query: self.searchQuery)

        userListViewController = PaginatedTableViewController<User, UserBoxView>(resourcePath: "users", query: self.searchQuery)
        tabs = Tab(textKeys: ["Débats", "Utilisateurs"], callbackFunc: useTabs)
        header.text = UtilsProvider.getLocalizedString(textKey: "search_header") + " \"" + searchQuery + "\""
        header.font = header.font.withSize(20)
        initLayout()

        setTab(tabIndex: 0)
    }
    
    func initLayout() {
        self.view.addSubview(header)
        self.view.addSubview(tabs!)
        self.view.addSubview(resultList)
        
        header.translatesAutoresizingMaskIntoConstraints = false
        header.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().offset(15)
            make.left.equalToSuperview()
        }
        
        tabs!.snp.makeConstraints { (make) -> Void in
            make.left.right.leading.trailing.equalToSuperview()
            make.top.equalTo(header.snp.bottom).offset(15)
        }
        
        resultList.translatesAutoresizingMaskIntoConstraints = false
        resultList.snp.makeConstraints { (make) -> Void in
            make.left.right.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(tabs!.snp.bottom).offset(15)
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
            default:
                return
        }
    }

    func setTab(tabIndex: Int) {
        if(tabIndex == 0) {
            removeTab()
            addChild(debateListViewController!)
            addTabView(viewController: debateListViewController!)
            self.currentTab = 0
            tabs?.setActive(tabIndex: 0)
        } else if(tabIndex == 1) {
            removeTab()
            addChild(userListViewController!)
            addTabView(viewController: userListViewController!)
            self.currentTab = 1
            tabs?.setActive(tabIndex: 1)
        }
    }

    func addTabView(viewController: UIViewController) {
        let childView = viewController.view!
        resultList.addSubview(childView)
        childView.translatesAutoresizingMaskIntoConstraints = false
        childView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(resultList)
        }
        viewController.didMove(toParent: self)
    }

    func removeTab() {
        if self.children.count > 0 {
            let viewControllers:[UIViewController] = self.children
            viewControllers.last?.willMove(toParent: nil)
            viewControllers.last?.removeFromParent()
            viewControllers.last?.view.removeFromSuperview()
        }
     }
}
