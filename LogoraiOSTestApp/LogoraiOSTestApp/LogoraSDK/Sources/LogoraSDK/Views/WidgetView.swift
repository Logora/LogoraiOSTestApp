import UIKit
import SnapKit

public class WidgetView: UIView {
    let apiClient = APIClient.sharedInstance
    let router = Router.sharedInstance
    let utilsProvider = UtilsProvider.sharedInstance
    private var applicationName: String!
    private var pageUid: String!
    private var debate: DebateSynthesis!
    private var debateName: UILabel! = UILabel()
    private var debateButton: PrimaryButton! = PrimaryButton(textKey: "Aller au débat")
    
    public init(applicationName: String, pageUid: String) {
        self.applicationName = applicationName
        self.pageUid = pageUid
        super.init(frame: .zero)
        getSynthesis()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.applicationName = ""
        self.pageUid = ""
        super.init(coder: aDecoder)
        getSynthesis()
    }
    
    func getSynthesis() {
        SettingsProvider.sharedInstance.getSettings(completion: {
            DispatchQueue.main.async {
                self.apiClient.getSynthesis(uid: self.pageUid, applicationName: self.applicationName, completion: { debate in
                    DispatchQueue.main.async {
                        self.debate = debate
                        self.initLayout()
                        self.initActions()
                    }
                }, error: { error in
                    print(error)
                })
            }
        })
    }
    
    func initLayout() {
        let container = UIStackView()
        self.addSubview(container)
        container.addArrangedSubview(debateName)
        container.addArrangedSubview(debateButton)
        container.axis = .horizontal
        container.distribution = .equalSpacing
        container.alignment = .center
        container.spacing = 15
        container.isLayoutMarginsRelativeArrangement = true
        container.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        container.isUserInteractionEnabled = true
        
        container.addBorder(hexString: SettingsProvider.sharedInstance.getTheme(key: "borderBoxColor"), width: 0.2)
        container.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self)
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.height.greaterThanOrEqualTo(100)
        }
        
        debateName.numberOfLines = 0
        debateName.text = self.debate.name
        debateName.setToSubtitle()
    }
    
    func initActions() {
        self.isUserInteractionEnabled = true
        self.debateButton.isUserInteractionEnabled = true
        self.debateButton.addTarget(self, action: #selector(goToDebate), for: .touchUpInside)
    }
    
    @objc func goToDebate(sender: UIButton!) {
        let vc = LogoraApp(applicationName: self.applicationName, authAssertion: "eyJ1aWQiOiJjZTM4NmE1OS00ZWU1LTRiMzQtYWNhZS02NTkwY2Q2M2I3ZTciLCJmaXJzdF9uYW1lIjoiZ2xrZWpsZ2tqIiwibGFzdF9uYW1lIjoibGtqZGxramZsa2oiLCJlbWFpbCI6InRlc3QzQGxvZ29yYS5mciIsInBhc3N3b3JkIjoicGFzc3dvcmQifQ==", routeName: "DEBATE", routeParam: self.debate.slug)
        self.parentViewController!.navigationController?.pushViewController(vc, animated: true)
    }
}
