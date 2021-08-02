import UIKit

class ArgumentMoreModal: UIView {
    private var argument: Message!
    private var deleteArgument: UILabel! = UILabel()
    private var updateArgument: UILabel! = UILabel()
    private var reportArgument: UILabel! = UILabel()
    private var isUserConnected: Bool = false
    
    weak var listener: ArgumentFooterReportListener? = nil
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup(isUserConnected: Bool) {
        self.isUserConnected = isUserConnected
        self.initLayout()
        self.initActions()
    }
    
    func initLayout() {
        self.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self)
        }
        
        if(isUserConnected == true) {
            self.addSubview(self.updateArgument)
            self.addSubview(self.deleteArgument)
            self.addSubview(self.reportArgument)
            
            self.updateArgument.text = UtilsProvider.getLocalizedString(textKey: "debate_edit_vote")
            self.updateArgument.snp.makeConstraints { (make) in
                make.bottom.equalTo(self.deleteArgument.snp.top).offset(-15)
                make.left.right.equalTo(self)
            }
            
            self.deleteArgument.text = UtilsProvider.getLocalizedString(textKey: "delete")
            self.deleteArgument.snp.makeConstraints { (make) in
                make.centerY.equalTo(self.snp.centerY)
                make.left.right.equalTo(self)
            }
            
            self.reportArgument.text = UtilsProvider.getLocalizedString(textKey: "report")
            self.reportArgument.snp.makeConstraints { (make) in
                make.top.equalTo(self.deleteArgument.snp.bottom).offset(15)
                make.left.right.equalTo(self)
            }
        } else {
            self.addSubview(self.reportArgument)
            
            self.reportArgument.text = UtilsProvider.getLocalizedString(textKey: "report")
            self.reportArgument.snp.makeConstraints { (make) in
                make.top.equalTo(self)
                make.left.right.equalTo(self)
            }
        }
    }
    
    func initActions() {
        self.isUserInteractionEnabled = true
        self.reportArgument.isUserInteractionEnabled = true
        self.reportArgument.setOnClickListener(action: triggerReportModal, clickedObject: nil)
    }
    
    func triggerReportModal(clickedObject: Any?) {
        listener?.openReportModal()
    }
}

@objc protocol ArgumentFooterReportListener: AnyObject {
    func openReportModal()
}
