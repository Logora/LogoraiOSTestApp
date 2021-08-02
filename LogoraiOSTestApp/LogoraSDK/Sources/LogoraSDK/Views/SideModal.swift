import UIKit

class SideModal: UIView {
    private final var inputProvider = InputProvider.sharedInstance
    private var debate: Debate!
    private var sideModalTitle: UILabel! = UILabel()
    private var debateTitle: UILabel! = UILabel()
    private var firstPositionButton: UIButton! = UIButton()
    private var secondPositionButton: UIButton! = UIButton()
    
    weak var listener: ArgumentInputListener? = nil
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup(debate: Debate) {
        self.debate = debate
        initLayout()
        initActions()
    }
    
    func initLayout() {
        let sideButtonsContainer = UIView()
        sideButtonsContainer.isUserInteractionEnabled = true
        self.addSubview(self.sideModalTitle)
        self.addSubview(self.debateTitle)
        sideButtonsContainer.addSubview(self.firstPositionButton)
        sideButtonsContainer.addSubview(self.secondPositionButton)
        self.addSubview(sideButtonsContainer)
        
        self.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self)
        }
        
        self.sideModalTitle.text = UtilsProvider.getLocalizedString(textKey: "side_dialog_header")
        self.sideModalTitle.setToSubtitle()
        self.sideModalTitle.setToBold()
        self.sideModalTitle.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self)
            make.left.equalTo(self)
        }
        
        self.debateTitle.text = "Doit-on supprimer l'ISF ?"
        self.debateTitle.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.sideModalTitle.snp.bottom).offset(25)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        sideButtonsContainer.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.debateTitle.snp.bottom).offset(25)
            make.bottom.equalTo(self.firstPositionButton.snp.bottom)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        self.firstPositionButton.setTitle("Oui", for: .normal)
        self.firstPositionButton.layer.borderWidth = 0.6
        self.firstPositionButton.layer.cornerRadius = 6
        self.firstPositionButton.titleLabel?.setToSubtitle()
        self.firstPositionButton.titleLabel?.setToBold()
        self.firstPositionButton.uppercased()
        self.firstPositionButton.tintColor = UIColor.white
        self.firstPositionButton.addShadow(offset: CGSize.init(width: 0, height: 1), color: UIColor.init(hexString: SettingsProvider.sharedInstance.getTheme(key: "borderBoxColor")), radius: 4, opacity: 0.35)
        self.firstPositionButton.layer.borderColor = UIColor.init(hexString: SettingsProvider.sharedInstance.get(key: "theme.forPrimaryColor")).cgColor
        self.firstPositionButton.backgroundColor = UIColor.init(hexString: SettingsProvider.sharedInstance.get(key: "theme.forPrimaryColor"))
        self.firstPositionButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(sideButtonsContainer)
            make.left.equalTo(sideButtonsContainer)
            make.width.greaterThanOrEqualTo(60)
        }
        
        self.secondPositionButton.setTitle("Non", for: .normal)
        self.secondPositionButton.layer.borderWidth = 0.6
        self.secondPositionButton.layer.cornerRadius = 6
        self.secondPositionButton.titleLabel?.setToSubtitle()
        self.secondPositionButton.titleLabel?.setToBold()
        self.secondPositionButton.uppercased()
        self.secondPositionButton.tintColor = UIColor.white
        self.secondPositionButton.addShadow(offset: CGSize.init(width: 0, height: 1), color: UIColor.init(hexString: SettingsProvider.sharedInstance.getTheme(key: "borderBoxColor")), radius: 4, opacity: 0.35)
        self.secondPositionButton.layer.borderColor = UIColor.init(hexString: SettingsProvider.sharedInstance.get(key: "theme.againstPrimaryColor")).cgColor
        self.secondPositionButton.backgroundColor = UIColor.init(hexString: SettingsProvider.sharedInstance.get(key: "theme.againstPrimaryColor"))
        self.secondPositionButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(sideButtonsContainer)
            make.right.equalTo(sideButtonsContainer)
            make.left.equalTo(self.firstPositionButton.snp.right).offset(15)
            make.width.greaterThanOrEqualTo(60)
        }
    }
    
    func initActions() {
        self.isUserInteractionEnabled = true
        self.firstPositionButton.isUserInteractionEnabled = true
        self.secondPositionButton.isUserInteractionEnabled = true
        self.firstPositionButton.setOnClickListener(action: chooseFirstPosition, clickedObject: nil)
        self.secondPositionButton.setOnClickListener(action: chooseSecondPosition, clickedObject: nil)
    }
    
    func chooseFirstPosition(clickedObject: Any?) {
        self.inputProvider.setUserPositions(debateId: debate.id, positionId: debate.groupContext.positions[0].id);
        if (listener != nil) {
            listener!.onArgumentReady(positionId: debate.groupContext.positions[0].id);
            self.parentViewController!.dismiss(animated: true, completion: nil)
        }
    }
    
    func chooseSecondPosition(clickedObject: Any?) {
        self.inputProvider.setUserPositions(debateId: debate.id, positionId: debate.groupContext.positions[1].id);
        if (listener != nil) {
            listener!.onArgumentReady(positionId: debate.groupContext.positions[1].id);
            self.parentViewController!.dismiss(animated: true, completion: nil)
        }
    }
}

@objc protocol ArgumentInputListener: AnyObject {
    func onArgumentReady(positionId: Int)
}
