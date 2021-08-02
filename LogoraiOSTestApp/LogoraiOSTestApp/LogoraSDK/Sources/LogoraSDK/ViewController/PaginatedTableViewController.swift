import UIKit
import SnapKit

class PaginatedTableViewController<T: Codable & Routable, Cell: UITableViewCell & CellElement>: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let apiClient = APIClient.sharedInstance
    let router = Router.sharedInstance
    private var resourcePath: String
    private var resourceList: [T] = []
    private var totalItems: Int = 0
    private var totalPages: Int = 0
    private var page: Int = 1
    private var perPage: Int = 10
    private var sort: String = "-created_at"
    private var query: String = ""
    private var initObject: ((T) -> T)?
    private var filterList: (([T]) -> [T])?
    private var cellHeight: CGFloat? = UITableView.automaticDimension
    private var hasLoader: Bool = true
    private var contentSizeObservation: NSKeyValueObservation?
    private var tableHeight: Int = 0
    private var PADDING: Int = 15

    weak var listener: ListDidFinishLayoutListener? = nil
    var tableView: UITableView!
    lazy var loadMoreButton: UIButton! = PrimaryButton(textKey: "actionSeeMore")
    lazy var emptyView: UILabel! = UILabel()
    lazy var loadViewController: SpinnerViewController! = SpinnerViewController()

    public init(resourcePath: String, perPage: Int = 10, sort: String = "-created_at", query: String = "", initObject: ((T) -> T)? = nil, hasLoader: Bool = true, filterList: (([T]) -> [T])? = nil) {
        self.resourcePath = resourcePath
        self.perPage = perPage
        self.sort = sort
        self.query = query
        self.initObject = initObject
        self.filterList = filterList
        self.hasLoader = hasLoader
        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder aDecoder: NSCoder) {
        self.resourcePath = ""
        self.perPage = 10
        self.sort = "-created_at"
        self.query = ""
        super.init(coder: aDecoder)
    }
    
    deinit {
        contentSizeObservation?.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView = UITableView()
        tableView.register(Cell.self, forCellReuseIdentifier: "Cell")

        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100.0

        emptyView.text = UtilsProvider.getLocalizedString(textKey: "list_empty")
        
        loadList(appendItems: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initActions()
        initLayout()
        
        contentSizeObservation = self.tableView.observe(\.contentSize, options: .new, changeHandler: { [weak self] (tv, _) in
            guard let self = self else { return }
            self.listener?.listDidFinishLayout(tableHeight: tv.contentSize.height + self.loadMoreButton.frame.height + CGFloat(2 * self.PADDING), cellType: String(describing: Cell.self))
        })
    }

    func initLayout() {
        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)
        self.view.addSubview(emptyView)
        self.view.addSubview(loadMoreButton)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.snp.makeConstraints { (make) -> Void in
            make.left.right.leading.trailing.top.equalToSuperview()
            if(self.hasLoader == true) {
                make.bottom.equalTo(self.loadMoreButton.snp.top).offset(-PADDING)
            } else {
                make.bottom.equalToSuperview()
            }
        }
        tableView.isScrollEnabled = false
        
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        emptyView.isHidden = true
        emptyView.textAlignment = .center
        emptyView.snp.makeConstraints { (make) -> Void in
            make.left.right.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(0)
        }
        
        loadMoreButton.translatesAutoresizingMaskIntoConstraints = false
        self.loadMoreButton.isHidden = true
        if(self.hasLoader == true) {
            self.loadMoreButton.isHidden = false
            loadMoreButton.snp.makeConstraints { (make) -> Void in
                make.centerX.equalToSuperview()
                make.top.equalTo(tableView.snp.bottom).offset(PADDING)
                make.bottom.equalToSuperview().offset(-PADDING)
            }
        } else {
            loadMoreButton.snp.makeConstraints { (make) -> Void in
                make.height.equalTo(0)
            }
        }
    }
    
    func initActions() {
        loadMoreButton.addTarget(self, action: #selector(self.loadMoreOnClick(sender:)), for: .touchUpInside)
    }

    func loadList(appendItems: Bool) {
        DispatchQueue.main.async {
            self.addChild(self.loadViewController)
            self.loadViewController.view.frame = self.view.frame
            self.view.addSubview(self.loadViewController.view)
            self.loadViewController.didMove(toParent: self)

            self.apiClient.getList(resourcePath: self.resourcePath, resource: T.self, page: self.page, perPage: self.perPage, sort: self.sort, query: self.query, completion: { (resourceList, totalItems, totalPages)  in
                if ((self.initObject) != nil) {
                    self.resourceList = resourceList.map { self.initObject!($0) }
                }
                if ((self.filterList) != nil) {
                    self.resourceList = self.filterList!(resourceList)
                }
                if appendItems == true {
                    self.resourceList += resourceList
                } else {
                    self.resourceList = resourceList
                }
                self.totalItems = totalItems
                self.totalPages = totalPages
                DispatchQueue.main.async {
                    if(self.totalItems == 0) {
                        self.tableView.isHidden = true
                        self.emptyView.isHidden = false
                    }

                    if(self.totalPages == self.page) {
                        self.loadMoreButton.isHidden = true
                    }
                    self.loadViewController.willMove(toParent: nil)
                    self.loadViewController.view.removeFromSuperview()
                    self.loadViewController.removeFromParent()
                    self.tableView.reloadData()
                }
            }, error: { error in
                DispatchQueue.main.async {
                    self.tableView.isHidden = true
                    self.emptyView.isHidden = false
                    self.loadViewController.willMove(toParent: nil)
                    self.loadViewController.view.removeFromSuperview()
                    self.loadViewController.removeFromParent()
                }
            })
        }
    }

    func loadMore() {
        self.page += 1
        self.loadList(appendItems: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resourceList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Cell
        let currentResource = resourceList[indexPath.row]
        cell.setResource(resource: currentResource)
        cell.isUserInteractionEnabled = true
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let resource = resourceList[indexPath.row]
        if (resource.getRouteParam() != "") {
            router.setRoute(routeName: resource.getRouteName(), routeParam: resource.getRouteParam())
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    public func addElementOnTop(element: Any) {
        let element = element as! T
        self.resourceList.insert(element, at: 0)
        self.tableView.reloadData()
    }
    
    public func removeElement(element: Any) {
        let element = element as! T
        if let idx = self.resourceList.firstIndex(where: { $0 === element }) {
            self.resourceList.remove(at: idx)
        }
    }

    @objc func loadMoreOnClick(sender: UIButton!) {
        DispatchQueue.main.async {
            self.loadMoreButton.isHidden = true
            self.loadMore()
        }
    }
}

@objc protocol ListDidFinishLayoutListener: AnyObject {
    func listDidFinishLayout(tableHeight: CGFloat, cellType: String)
}
