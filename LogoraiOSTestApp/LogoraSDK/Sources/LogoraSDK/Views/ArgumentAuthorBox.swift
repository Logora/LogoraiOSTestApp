import UIKit
import SnapKit
import Kingfisher

class ArgumentAuthorBox: UIView {
    private final var router = Router.sharedInstance
    var author: User?
    var defaultAuthor: DefaultAuthor! = DefaultAuthor()
    var isInput: Bool!
    var isDefaultAuthor: Bool!
    var authorImage: UIImageView! = UIImageView()
    var authorFullName: UILabel! = UILabel()
    var authorLevelName: UILabel! = UILabel()
    var authorLevelIcon: UIImageView! = UIImageView()
    var positionLabel: UILabel! = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup(isInput: Bool, author: User?, defaultAuthor: DefaultAuthor?, isDefaultAuthor: Bool) {
        self.isInput = isInput
        self.author = author
        self.defaultAuthor = defaultAuthor
        self.isDefaultAuthor = isDefaultAuthor
        initLayout()
        initAuthor()
        initActions()
    }
    
    func initLayout() {
        self.addSubview(authorImage)
        self.addSubview(authorFullName)
        self.addSubview(authorLevelName)
        self.addSubview(authorLevelIcon)
    
        self.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self)
            make.left.right.leading.trailing.equalTo(self)
            make.bottom.equalTo(self.authorLevelName.snp.bottom)
            make.height.greaterThanOrEqualTo(self.authorImage)
        }

        self.authorImage.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self)
            make.left.equalTo(self)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        self.authorFullName.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.authorImage.snp.top)
            make.left.equalTo(self.authorImage.snp.right).offset(15)
            make.bottom.equalTo(self.authorLevelName.snp.top).offset(-3)
        }
        
        self.authorLevelName.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.authorFullName.snp.bottom).offset(3)
            make.left.equalTo(self.authorImage.snp.right).offset(15)
        }
        
        self.authorLevelIcon.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.authorFullName.snp.bottom).offset(3)
            make.left.equalTo(self.authorLevelName.snp.right).offset(5)
            make.width.height.equalTo(20)
        }
    }
    
    func initAuthor() {
        self.authorFullName.setToBold()
        self.authorLevelName.setToSecondaryText()
        switch(self.isDefaultAuthor) {
            case true:
                self.authorImage.kf.setImage(with: URL(string: self.defaultAuthor.imageUrl))
                self.authorImage.layoutIfNeeded()
                self.authorImage.makeRounded()
                self.authorFullName.text = self.defaultAuthor.fullName
                self.authorLevelName.text = self.defaultAuthor.levelName
                self.authorLevelIcon.kf.setImage(with: URL(string: self.defaultAuthor.iconUrl))
            case false:
                self.authorImage.kf.setImage(with: URL(string: (self.author?.imageURL!)!))
                self.authorImage.layoutIfNeeded()
                self.authorImage.makeRounded()
                self.authorFullName.text = self.author?.fullName
                self.authorLevelName.text = UtilsProvider.getLocalizedString(textKey: "user_box_level")
                self.authorLevelIcon.kf.setImage(with: URL(string: (self.author?.level!.iconURL)!)!)
            case .none:
                return
            case .some(_):
                return
        }
    }
    
    func initActions(){
        self.isUserInteractionEnabled = true
        self.authorFullName.isUserInteractionEnabled = true
        self.authorImage.isUserInteractionEnabled = true
        if (isInput == false) {
            self.authorFullName.setOnClickListener(action: goToUserProfile)
            self.authorImage.setOnClickListener(action: goToUserProfile)
        }
    }
    
    func goToUserProfile(clickedObject: Any?) {
        router.setRoute(routeName: "USER", routeParam: (self.author?.slug)!)
    }
}
