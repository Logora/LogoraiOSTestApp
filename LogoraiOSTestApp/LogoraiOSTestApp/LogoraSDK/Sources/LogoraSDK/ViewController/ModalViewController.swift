import UIKit
import SnapKit

class ModalViewController: UIViewController {
    private var modalView = UIView()
    private var containerView = UIView()
    private var modalHeight: Int = 300
    private var modalWidth: Int = 300
    
    override func viewDidLoad() {
        initLayout()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if touch?.view == self.view {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    public init(modalView: UIView, modalHeight: Int, modalWidth: Int) {
        super.init(nibName: nil, bundle: nil)
        self.modalView = modalView
        self.modalHeight = modalHeight
        self.modalWidth = modalWidth
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initLayout() {
        self.view.backgroundColor = UIColor.clear
        self.view.isOpaque = false
        self.containerView.backgroundColor = UIColor.white
        self.view.addSubview(self.containerView)
        self.containerView.addSubview(self.modalView)
        self.containerView.addBorder(hexString: SettingsProvider.sharedInstance.getTheme(key: "borderBoxColor"), width: 0.2)
        self.containerView.addShadow(offset: CGSize.init(width: 0, height: 1), color: UIColor.init(hexString: SettingsProvider.sharedInstance.getTheme(key: "borderBoxColor")), radius: 5, opacity: 0.35)
        self.containerView.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.view.snp.centerX)
            make.centerY.equalTo(self.view.snp.centerY)
            make.width.equalTo(self.modalWidth)
            make.height.equalTo(self.modalHeight)
        }
        
        self.modalView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self.containerView.snp.width).inset(10)
            make.height.equalTo(self.containerView.snp.height).inset(10)
            make.centerY.equalTo(self.containerView.snp.centerY).inset(10)
            make.centerX.equalTo(self.containerView.snp.centerX).inset(10)
        }
    }
}
