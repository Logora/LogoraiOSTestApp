import UIKit
import SnapKit

class DebateContextView: UIView {
    private final var router = Router.sharedInstance
    var debate: Debate!
    private var debateShowDate: UILabel! = UILabel()
    private var debateShowTitle: UILabel! = UILabel()
    private var tagStackView: UIStackView = UIStackView()
    private var separator: UIView! = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup(debate: Debate) {
        self.debate = debate
        initLayout()
    }
    
    func initLayout() {
        self.addSubview(self.debateShowDate)
        self.addSubview(self.debateShowTitle)
        self.addSubview(self.tagStackView)
        self.addSubview(self.separator)
        
        self.tagStackView.alignment = .center
        self.tagStackView.axis = .horizontal
        self.tagStackView.distribution = .fill
        self.tagStackView.spacing = 5
        
        self.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self)
            make.left.right.leading.trailing.equalTo(self)
            make.bottom.equalTo(self.separator.snp.bottom)
        }

        self.debateShowDate.text = "\(debate.createdAt.toDate()!.localizedDate())"
        self.debateShowDate.setToSecondaryText()
        self.debateShowDate.setToSecondaryTextColor()
        self.debateShowDate.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self)
            make.left.right.leading.trailing.equalTo(self)
        }
        
        self.debateShowTitle.text = debate?.name
        self.debateShowTitle.numberOfLines = 0
        self.debateShowTitle.setToTitle()
        self.debateShowTitle.setToBold()
        self.debateShowTitle.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.debateShowDate.snp.bottom).offset(15)
            make.left.right.leading.trailing.equalTo(self)
        }
        
        self.tagStackView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.debateShowTitle.snp.bottom).offset(15)
            make.left.leading.equalTo(self)
        }
        
        self.separator.backgroundColor = UIColor.init(hexString: SettingsProvider.sharedInstance.getTheme(key: "borderBoxColor"))
        self.separator.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.tagStackView.snp.bottom).offset(15)
            make.left.leading.equalTo(self)
            make.height.equalTo(0.3)
            make.width.equalTo(self.snp.width)
        }
        
        if (self.debate.groupContext.tags!.count > 1) {
            self.debate.groupContext.tags!.enumerated().forEach { (index, tag) in
                let tagView = UIView()
                let label = UILabel()
                self.tagStackView.addArrangedSubview(tagView)
                tagView.isUserInteractionEnabled = true
                tagView.addBorder(hexString: SettingsProvider.sharedInstance.get(key: "theme.callPrimaryColor"), width: 1)
                tagView.addSubview(label)
                tagView.setOnClickListener(action: searchWithTag, clickedObject: tag.name)
                label.isUserInteractionEnabled = true
                label.textColor = UIColor.init(hexString: SettingsProvider.sharedInstance.get(key: "theme.callPrimaryColor"))
                label.text = tag.name
                label.snp.makeConstraints { (make) -> Void in
                    make.top.equalTo(tagView).offset(5)
                    make.bottom.equalTo(tagView).offset(-5)
                    make.left.equalTo(tagView).offset(5)
                    make.right.equalTo(tagView).offset(-5)
                }
            }
        }
    }
    
    func searchWithTag(clickedObject: Any?) {
        router.setRoute(routeName: "SEARCH", routeParam: clickedObject as! String)
    }
    
}
