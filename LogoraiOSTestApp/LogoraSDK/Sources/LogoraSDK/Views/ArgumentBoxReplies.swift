import UIKit
import SnapKit

class ArgumentBoxReplies: UIView {
    private final var apiClient = APIClient.sharedInstance
    private var argument: Message!
    private var repliesList: UIView! = UIView()
    private var toggleArgumentsLabel: UILabel! = UILabel()
    private var firstReplyUser: UIImageView! = UIImageView()
    private var secondReplyUser: UIImageView! = UIImageView()
    private var thirdReplyUser: UIImageView! = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup(argument: Message) {
        self.argument = argument
        let repliesListViewController = PaginatedTableViewController<Message, ArgumentBox>(resourcePath: "/messages/\(argument.id)/replies")
        self.repliesList = repliesListViewController.view
        self.initLayout()
    }
    
    func initLayout() {
        self.addSubview(firstReplyUser)
        self.addSubview(secondReplyUser)
        self.addSubview(thirdReplyUser)
        self.addSubview(toggleArgumentsLabel)
        
        self.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self)
            make.left.right.leading.trailing.equalTo(self)
            make.bottom.equalTo(self)
        }
        
        self.initReplyUsers()
    }
    
    func initReplyUsers() {
        let replyUsers = argument.repliesAuthors?.prefix(3)
        if replyUsers?.count == 0 {
            toggleArgumentsLabel.isHidden = true
            self.snp.remakeConstraints { (make) -> Void in
                make.top.equalTo(self)
                make.left.right.leading.trailing.equalTo(self)
                make.bottom.equalTo(self)
                make.height.equalTo(0)
            }
        } else if (replyUsers != nil) {
            toggleArgumentsLabel.setToSecondaryText()
            toggleArgumentsLabel.isHidden = false
            toggleArgumentsLabel.text = "Voir \(replyUsers!.count) réponses"
            replyUsers?.enumerated().forEach { (index, replyUser) in
                let imageUrl = URL(string: replyUser.imageURL!)
                switch index {
                    case 0:
                        firstReplyUser.makeRounded()
                        firstReplyUser.kf.setImage(with: imageUrl)
                        firstReplyUser.snp.makeConstraints { (make) in
                            make.top.equalTo(self)
                            make.left.equalTo(self)
                            make.height.width.equalTo(25)
                        }
                        toggleArgumentsLabel.snp.makeConstraints { (make) in
                            make.top.equalTo(self)
                            make.left.equalTo(self.firstReplyUser.snp.right).offset(5)
                            make.centerY.equalTo(self.snp.centerY)
                        }
                    case 1:
                        secondReplyUser.makeRounded()
                        secondReplyUser.kf.setImage(with: imageUrl)
                        secondReplyUser.snp.makeConstraints { (make) in
                            make.top.equalTo(self)
                            make.left.equalTo(self.firstReplyUser.snp.right).offset(5)
                            make.height.width.equalTo(25)
                        }
                        toggleArgumentsLabel.snp.remakeConstraints { (make) in
                            make.top.equalTo(self)
                            make.left.equalTo(self.secondReplyUser.snp.right).offset(5)
                            make.centerY.equalTo(self.snp.centerY)
                        }
                    case 2:
                        thirdReplyUser.makeRounded()
                        thirdReplyUser.kf.setImage(with: imageUrl)
                        thirdReplyUser.snp.makeConstraints { (make) in
                            make.top.equalTo(self)
                            make.left.equalTo(self.secondReplyUser.snp.right).offset(5)
                            make.height.width.equalTo(25)
                        }
                        toggleArgumentsLabel.snp.remakeConstraints { (make) in
                            make.top.equalTo(self)
                            make.left.equalTo(self.thirdReplyUser.snp.right).offset(5)
                            make.centerY.equalTo(self.snp.centerY)
                        }
                    default:
                        return
                }
            }
        }
    }
    
    func initActions() {
        self.isUserInteractionEnabled = true
        self.toggleArgumentsLabel.isUserInteractionEnabled = true
        self.toggleArgumentsLabel.setOnClickListener(action: toggleReplies, clickedObject: nil)
    }
    
    func toggleReplies(clickedObject: Any?) {
        self.toggleArgumentsLabel.text = UtilsProvider.getLocalizedString(textKey: "argument_hide_replies")
        self.repliesList.snp.makeConstraints{ (make) in
            make.top.equalTo(self.toggleArgumentsLabel.snp.bottom).offset(10)
            make.left.equalTo(self)
        }
    }
}
