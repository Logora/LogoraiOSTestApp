import UIKit
import LogoraSDK

class ViewController: UIViewController {
    var vc: UIViewController? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Retour à l'article"
        initLayout()
    }
    
    func initLayout() {
        let widget: WidgetView! = WidgetView(applicationName: "logora-demo", pageUid: "1162254885")
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

