import UIKit
import SnapKit

class DebateViewController: UIViewController, AddElementToListListener {
    let apiClient = APIClient.sharedInstance
    let utilsProvider = UtilsProvider.sharedInstance
    private var debateSlug: String!
    private var debate: Debate?
    private var headerView: UIView! = UIView()
    private var debateContextView: DebateContextView! = DebateContextView()
    private var voteBoxView: VoteBoxView! = VoteBoxView()
    private var debateContextFooterView: DebateContextFooterView! = DebateContextFooterView()
    private var argumentInputContainer = UIView()
    private var argumentInput: ArgumentInput! = ArgumentInput()
    private var relatedDebatesLabel: UILabel! = UILabel()
    private var argumentListViewController: PaginatedTableViewController<Message, ArgumentBox>?
    lazy var argumentList: UIView! = UIView()
    lazy var relatedDebates: UIView! = UIView()
    
    public init(debateSlug: String) {
        self.debateSlug = debateSlug
        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder aDecoder: NSCoder) {
        self.debateSlug = ""
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        argumentInput.listener = self
        DispatchQueue.main.async {
            self.utilsProvider.showLoader(currentVC: self)
        }
        self.apiClient.getDebate(slug: self.debateSlug, completion: { debate in
            DispatchQueue.main.async {
                self.debate = debate
                self.debate?.initVotePercentage()
                self.debateContextView.setup(debate: debate)
                self.voteBoxView.setup(debate: debate)
                self.debateContextFooterView.setup(debate: debate)
                self.argumentInput.setup(debate: debate)
                self.argumentListViewController = PaginatedTableViewController<Message, ArgumentBox>(resourcePath: "groups/\(self.debateSlug!)/messages", perPage: 4, initObject: self.setDebate, filterList: self.filterArguments)
                self.addChild(self.argumentListViewController!)
                self.argumentList = self.argumentListViewController!.view
                let relatedDebatesListViewController = PaginatedTableViewController<Debate, DebateBoxView>(resourcePath: "groups/\(self.debateSlug!)/related", perPage: 4, hasLoader: false)
                self.addChild(relatedDebatesListViewController)
                self.relatedDebates = relatedDebatesListViewController.view
                self.initLayout()
                self.utilsProvider.hideLoader()
            }
        }, error: { error in
            print(error)
        })
    }
    
    func setDebate(object: Any?) -> Message {
        let argument = object as! Message
        argument.group = self.debate
        return argument
    }
    
    func filterArguments(object: [Any]?) -> [Message] {
        var argumentsList = object as! [Message]
        argumentsList = argumentsList.filter { arg in
            if(arg.status == "accepted") {
                return true
            } else if (arg.status == "pending" || arg.status == "rejected") {
                if ((AuthService.sharedInstance.getLoggedIn() == true) && (arg.author.id == AuthService.sharedInstance.getCurrentUser().id)) {
                    return true
                }
            }
            return false
        }
        return argumentsList
    }
    
    func initLayout() {
        self.view.addSubview(self.headerView)
        self.view.addSubview(debateContextView)
        self.view.addSubview(voteBoxView)
        self.view.addSubview(debateContextFooterView)
        self.view.addSubview(self.argumentInputContainer)
        self.view.addSubview(argumentInput)
        self.view.addSubview(argumentList)
        self.view.addSubview(relatedDebatesLabel)
        self.view.addSubview(relatedDebates)
        
        self.headerView.addBorder(hexString: SettingsProvider.sharedInstance.getTheme(key: "borderBoxColor"), width: 0.2)
        self.headerView.snp.makeConstraints { (make) -> Void in
            make.top.left.right.equalTo(self.view)
            make.bottom.equalTo(self.debateContextFooterView.snp.bottom).offset(15)
        }

        self.debateContextView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.view).offset(15)
            make.left.equalTo(self.view).offset(15)
            make.right.equalTo(self.view).offset(-15)
        }
        
        self.voteBoxView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.debateContextView.snp.bottom).offset(15)
            make.left.equalTo(self.view).offset(15)
            make.right.equalTo(self.view).offset(-15)
        }
        
        self.debateContextFooterView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.voteBoxView.snp.bottom).offset(15)
            make.left.equalTo(self.view).offset(15)
            make.right.equalTo(self.view).offset(-15)
        }
        
        self.argumentInputContainer.addBorder(hexString: SettingsProvider.sharedInstance.getTheme(key: "borderBoxColor"), width: 0.2)
        self.argumentInputContainer.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.headerView.snp.bottom).offset(15)
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(self.argumentInput.snp.bottom)
        }
        
        self.argumentInput.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.argumentInputContainer.snp.top).offset(15)
            make.left.equalTo(self.view).offset(15)
            make.right.equalTo(self.view).offset(-15)
        }
        
        self.argumentList.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.argumentInput.snp.bottom).offset(15)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.bottom.equalTo(self.relatedDebatesLabel.snp.top).offset(-15)
        }
        
        self.relatedDebatesLabel.text = "Débats suggérés pour vous"
        self.relatedDebatesLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.argumentList.snp.bottom).offset(15)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
        }

        self.relatedDebates.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.relatedDebatesLabel.snp.bottom).offset(15)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
        }
    }
    
    func listDidFinishLayout(tableHeight: Int) {
//        self.relatedDebatesLabel.snp.remakeConstraints { (make) in
//            make.top.equalTo(self.argumentList.snp.bottom).offset(15)
//            make.left.equalTo(self.view)
//            make.right.equalTo(self.view)
//        }
//
//        self.relatedDebates.snp.remakeConstraints { (make) -> Void in
//            make.top.equalTo(self.relatedDebatesLabel.snp.bottom).offset(15)
//            make.left.equalTo(self.view)
//            make.right.equalTo(self.view)
//            make.bottom.equalTo(self.view)
//        }
    }

    func addElementToList(element: Any) {
        let argument = element as! Message
        let argumentListVC = self.argumentListViewController as! PaginatedTableViewController<Message, ArgumentBox>
        argumentListVC.addElementOnTop(element: argument)
    }
    
    func removeElementFromList(element: Any) {
        let argument = element as! Message
        let argumentListVC = self.argumentListViewController as! PaginatedTableViewController<Message, ArgumentBox>
        argumentListVC.removeElement(element: argument)
    }
}
