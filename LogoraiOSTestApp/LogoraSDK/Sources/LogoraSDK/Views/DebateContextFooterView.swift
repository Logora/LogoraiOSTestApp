import UIKit
import SnapKit

class DebateContextFooterView: UIView {
    private final var router = Router.sharedInstance
    var debateFollowed: Bool = false
    var debate: Debate!
    private var copyLinkIcon: UIImageView! = UIImageView()
    private var shareIcon: UIImageView! = UIImageView()
    private var followDebateButton: DebateFollowButton! = DebateFollowButton()
    
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup(debate: Debate) {
        self.debate = debate
        self.followDebateButton.initView(debate: debate)
        initLayout()
        initActions()
    }
    
    func initLayout() {
        self.addSubview(copyLinkIcon)
        self.addSubview(shareIcon)
        self.addSubview(followDebateButton)
        
        self.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self)
            make.left.right.leading.trailing.equalTo(self)
            make.bottom.equalTo(self.followDebateButton.snp.bottom)
        }
        
        if #available(iOS 13.0, *) {
            self.copyLinkIcon.image = UIImage(named: "copy", in: Bundle(for: type(of: self)), with: nil)
        }
        self.copyLinkIcon.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(self.followDebateButton.snp.centerY)
            make.left.equalTo(self)
            make.width.height.equalTo(20).priority(.required)
        }
        
        if #available(iOS 13.0, *) {
            self.shareIcon.image = UIImage(named: "share", in: Bundle(for: type(of: self)), with: nil)
        }
        self.shareIcon.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(self.followDebateButton.snp.centerY)
            make.left.equalTo(self.copyLinkIcon.snp.right).offset(15)
            make.width.height.equalTo(20).priority(.required)
        }
        
        self.followDebateButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self)
            make.right.equalTo(self)
        }
    }
    
    func initActions() {
        self.isUserInteractionEnabled = true
        self.followDebateButton.isUserInteractionEnabled = true
        self.shareIcon.isUserInteractionEnabled = true
        self.copyLinkIcon.isUserInteractionEnabled = true
        
        self.shareIcon.setOnClickListener(action: shareDebate, clickedObject: nil)
        self.copyLinkIcon.setOnClickListener(action: copyDebateLink, clickedObject: nil)
    }
    
    func shareDebate(clickedObject: Any?) {
        let urlString = "https://app.logora.fr/share/g/\(self.debate.id)"
        let activityController = UIActivityViewController(activityItems: [urlString], applicationActivities: nil)
        self.parentViewController!.present(activityController, animated: true, completion: nil)
    }
    
    func copyDebateLink(clickedObject: Any?) {
        let urlString = "https://app.logora.fr/share/g/\(self.debate.id)"
        let pasteboard = UIPasteboard.general
        pasteboard.string = urlString
        Toast.show(message: UtilsProvider.getLocalizedString(textKey: "link_copied"), controller: self.parentViewController!)
    }
}
