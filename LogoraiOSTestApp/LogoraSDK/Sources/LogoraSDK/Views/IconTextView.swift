import Foundation
import UIKit
import SnapKit
import SwiftSVG
import Kingfisher

class IconTextView: UIView {
    let settings: SettingsProvider = SettingsProvider.sharedInstance
    private var textKey: String!
    private var imageView: UIImageView! = UIImageView()
    private var imageUrl: String? = nil
    private var isImage: Bool! = false
    private var textContainer: UILabel = UILabel()
    private var stackView: UIStackView =  UIStackView()
    
    private var svgName: String!
    
    required init(imageView: UIImageView, textKey: String) {
        super.init(frame: .zero)
        self.textKey = textKey
        self.imageView = imageView
        self.svgName = ""
        self.isImage = false
        self.imageUrl = ""
        
        setup()
    }

    init(svgName: String, textKey: String) {
        super.init(frame: .zero)
        self.textKey = textKey
        self.svgName = svgName
        self.isImage = false
        self.imageUrl = ""
        
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.textKey = ""
        
        setup()
    }
    
    public func replaceImage(imageUrl: String, textKey: String) {
        self.imageUrl = imageUrl
        self.textKey = textKey
        self.isImage = true
        setup()
    }

    func setup() {
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.distribution = UIStackView.Distribution.equalCentering
        stackView.alignment = UIStackView.Alignment.center

        stackView.addArrangedSubview(imageView)
        
        stackView.addArrangedSubview(textContainer)
        textContainer.textAlignment = .center
        textContainer.text = UtilsProvider.getLocalizedString(textKey: self.textKey)
        textContainer.setToTertiaryText()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        if(self.isImage == true) {
            self.imageView.kf.setImage(with: URL(string: imageUrl!))
        } else {
            if #available(iOS 13.0, *) {
                self.imageView.image = UIImage(named: svgName, in: Bundle(for: type(of: self)), with: nil)
            }
        }
        
        self.imageView.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(20)
            make.centerX.equalTo(textContainer.snp.centerX)
        }

        self.addSubview(stackView)
        
        self.stackView.snp.makeConstraints { (make) -> Void in
            make.left.right.top.bottom.equalTo(self)
            make.height.equalTo(40)
        }
    }
}
