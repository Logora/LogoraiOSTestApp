import UIKit
import SnapKit

class ArgumentBoxFooter: UIView, ArgumentFooterReportListener {
    private final var auth = AuthService.sharedInstance
    private var footerContainer: UIStackView! = UIStackView()
    private var argumentVote: ArgumentVote! = ArgumentVote()
    private var argumentReply: UIImageView! = UIImageView()
    private var argumentShare: UIImageView! = UIImageView()
    private var argumentMore: UIImageView! = UIImageView()
    private var argument: Message!
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup(argument: Message) {
        self.argument = argument
        self.argumentVote.setup(argument: argument)
        initLayout()
        initActions()
    }
    
    func initLayout() {
        self.addSubview(self.footerContainer)
        self.footerContainer.addArrangedSubview(self.argumentVote)
        self.footerContainer.addArrangedSubview(self.argumentReply)
        self.footerContainer.addArrangedSubview(self.argumentShare)
        self.footerContainer.addArrangedSubview(self.argumentMore)
        
        self.footerContainer.axis = .horizontal
        self.footerContainer.alignment = .center
        self.footerContainer.distribution = .equalSpacing
        
        self.footerContainer.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self)
            make.left.right.leading.trailing.equalTo(self)
            make.bottom.equalTo(self)
            make.height.equalTo(28)
        }
        
        self.argumentVote.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(28).priority(.required)
            make.centerY.equalTo(self.snp.centerY)
        }
        
        if #available(iOS 13.0, *) {
            self.argumentReply.image = UIImage(named: "reply", in: Bundle(for: type(of: self)), with: nil)
        }
        self.argumentReply.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(22).priority(.required)
            make.centerY.equalTo(self.snp.centerY)
        }
        
        if #available(iOS 13.0, *) {
            self.argumentShare.image = UIImage(named: "share", in: Bundle(for: type(of: self)), with: nil)
        }
        self.argumentShare.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(22).priority(.required)
            make.centerY.equalTo(self.snp.centerY)
        }
        
        if #available(iOS 13.0, *) {
            self.argumentMore.image = UIImage(named: "ellipsis", in: Bundle(for: type(of: self)), with: nil)
        }
        self.argumentMore.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(25).priority(.required)
            make.centerY.equalTo(self.snp.centerY)
        }
    }
    
    func initActions() {
        self.isUserInteractionEnabled = true
        self.footerContainer.isUserInteractionEnabled = true
        self.argumentVote.isUserInteractionEnabled = true
        self.argumentReply.isUserInteractionEnabled = true
        self.argumentShare.isUserInteractionEnabled = true
        self.argumentMore.isUserInteractionEnabled = true
        
        self.argumentReply.setOnClickListener(action: replyButtonPressed, clickedObject: nil)
        self.argumentShare.setOnClickListener(action: shareButtonPressed, clickedObject: nil)
        self.argumentMore.setOnClickListener(action: moreButtonPressed, clickedObject: nil)
    }
    
    func replyButtonPressed(clickedObject: Any?) {
        if(auth.getLoggedIn() == true){
            // TODO: Lancer replyInput
        } else {
            let modalView = LoginModal()
            let modalViewController = ModalViewController(modalView: modalView, modalHeight: 400, modalWidth: 300)
            self.parentViewController!.present(modalViewController, animated: true, completion: nil)
        }
    }
    
    func shareButtonPressed(clickedObject: Any?) {
        let urlString = "https://app.logora.fr/share/a/\(self.argument.id)"
        let activityController = UIActivityViewController(activityItems: [urlString], applicationActivities: nil)
        self.parentViewController!.present(activityController, animated: true, completion: nil)
    }
    
    func moreButtonPressed(clickedObject: Any?) {
        let modalView = ArgumentMoreModal()
        modalView.listener = self
        modalView.setup(isUserConnected: auth.getLoggedIn())
        var modalHeight = 120
        if (AuthService.sharedInstance.getLoggedIn() == false) {
            modalHeight = 40
        }
        let modalViewController = ModalViewController(modalView: modalView, modalHeight: modalHeight, modalWidth: 300)
        self.parentViewController!.present(modalViewController, animated: true, completion: nil)
    }
    
    func openReportModal() {
        if(auth.getLoggedIn() == true) {
            let modalView = ReportModal()
            let modalViewController = ModalViewController(modalView: modalView, modalHeight: 350, modalWidth: 300)
            self.parentViewController!.dismiss(animated: true, completion: {
                self.parentViewController!.present(modalViewController, animated: true, completion: nil)
            })
        } else {
            let modalView = LoginModal()
            let modalViewController = ModalViewController(modalView: modalView, modalHeight: 400, modalWidth: 300)
            self.parentViewController!.dismiss(animated: true, completion: {
                self.parentViewController!.present(modalViewController, animated: true, completion: nil)
            })
        }
    }
}

