import UIKit
import SnapKit

class Tab: UIView {
    let settings: SettingsProvider = SettingsProvider.sharedInstance
    private var textKeys: [String]!
    private var callbackFunc: ((_ object: Any?) -> Void)!
    private var tabsArray: [[Int: UILabel]] = []
    private var underline: UIView! = UIView()
    
    lazy var stackView: UIStackView! = UIStackView()

    required init(textKeys: [String], callbackFunc: @escaping ((_ object: Any?) -> Void)) {
        super.init(frame: .zero)
        self.textKeys = textKeys
        self.callbackFunc = callbackFunc
        
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }

    func setup() {
        self.addSubview(stackView)
        self.addSubview(underline)
        
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        underline.backgroundColor = UIColor.init(hexString: SettingsProvider.sharedInstance.get(key: "theme.callPrimaryColor"))
        
        textKeys.enumerated().forEach { (index, text) in
            let labelContainer = UILabel()
            self.tabsArray.append([index: labelContainer])
            labelContainer.text = text
            labelContainer.textAlignment = .center
            stackView.addArrangedSubview(labelContainer)
            labelContainer.isUserInteractionEnabled = true
            labelContainer.setOnClickListener(action: self.callbackFunc, clickedObject: index)
        }
    }
    
    func setActive(tabIndex: Int) {
        self.tabsArray.enumerated().forEach { (index, element) in
            element[index]?.setToNormal()
            if (element.keys.first == tabIndex) {
                element[tabIndex]?.setToBold()
                underline.snp.remakeConstraints { (make) in
                    make.height.equalTo(3)
                    make.width.equalTo(element[tabIndex]?.snp.width as! ConstraintRelatableTarget)
                    make.top.equalTo(element[tabIndex]?.snp.bottom as! ConstraintRelatableTarget).offset(3)
                    make.left.equalTo(element[tabIndex]?.snp.left as! ConstraintRelatableTarget)
                }
            }
        }
    }
}

