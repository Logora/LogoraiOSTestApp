import UIKit
import LogoraSDK

class ViewController: UIViewController {
    var vc: UIViewController? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "App Container"
        if #available(iOS 13.0, *) {
            initLayout()
        }
    }
    
    func initLayout() {
        let widget: WidgetView! = WidgetView(applicationName: "logora-demo", pageUid: "e0a5e418-897c-40c3-8899-2f1152f8db52")
        self.view.addSubview(widget)
        
        widget.clipsToBounds = true
        widget.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.view.snp.centerY)
            make.left.equalTo(self.view).offset(15)
            make.right.equalTo(self.view).offset(-15)
            make.height.greaterThanOrEqualTo(100)
        }
    }
}

