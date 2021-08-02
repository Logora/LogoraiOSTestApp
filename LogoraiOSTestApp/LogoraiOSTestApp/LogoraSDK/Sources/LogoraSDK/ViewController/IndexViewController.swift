import UIKit
import SnapKit

class IndexViewController: UIViewController, ListDidFinishLayoutListener {
    let transparentView = UIView()
    let sortTableView = UITableView()
    var sortOptions: [String] = []

    lazy var debateListHeader: UILabel! = TextWrapper(textKey: "headerTrendingDebates")
    lazy var debateList: UIView! = UIView()

    lazy var userListHeader: UILabel! = TextWrapper(textKey: "headerBestUsers")
    lazy var userList: UIView! = UIView()

    public init() {
        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        let debateListViewController = PaginatedTableViewController<Debate, DebateBoxView>(resourcePath: "groups/index/trending", perPage: 6)
        let userListViewController = PaginatedTableViewController<User, UserBoxView>(resourcePath: "users/index/trending", perPage: 6, hasLoader: false)
        debateListViewController.listener = self
        userListViewController.listener = self
        addChild(debateListViewController)
        addChild(userListViewController)
        self.debateList = debateListViewController.view
        self.userList = userListViewController.view
        
        initLayout()
    }
    
    func listDidFinishLayout(tableHeight: CGFloat, cellType: String) {
        if(tableHeight > 0) {
            if(cellType == "DebateBoxView") {
                self.debateList.snp.updateConstraints { (make) -> Void in
                    make.height.equalTo(tableHeight)
                }
            } else if(cellType == "UserBoxView") {
                self.userList.snp.updateConstraints { (make) -> Void in
                    make.height.equalTo(tableHeight)
                }
            }
        }
    }

    public func initLayout() {
        self.view.addSubview(debateListHeader)
        self.view.addSubview(debateList)
        self.view.addSubview(userListHeader)
        self.view.addSubview(userList)
        
        self.view.translatesAutoresizingMaskIntoConstraints = false

        debateListHeader.translatesAutoresizingMaskIntoConstraints = false
        debateListHeader.setToSubtitle()
        debateListHeader.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.view).offset(15)
            make.bottom.equalTo(debateList.snp.top).offset(-15)
            make.left.right.equalToSuperview()
        }
        debateListHeader.sizeToFit()

        debateList.translatesAutoresizingMaskIntoConstraints = false
        debateList.snp.makeConstraints { (make) -> Void in
            make.left.right.equalToSuperview()
            make.top.equalTo(debateListHeader.snp.bottom).offset(15)
            make.bottom.equalTo(userListHeader.snp.top).offset(-15)
            make.height.equalTo(100)
        }
        
        userListHeader.setToSubtitle()
        userListHeader.translatesAutoresizingMaskIntoConstraints = false
        userListHeader.snp.makeConstraints { (make) -> Void in
            make.left.right.equalToSuperview()
            make.top.equalTo(debateList.snp.bottom).offset(15)
            make.bottom.equalTo(userList.snp.top).offset(-15)
        }
        userListHeader.sizeToFit()
        
        userList.snp.makeConstraints { (make) -> Void in
            make.left.right.equalToSuperview()
            make.top.equalTo(userListHeader.snp.bottom).offset(15)
            make.bottom.equalTo(self.view)
            make.height.equalTo(100)
        }
    }
}
