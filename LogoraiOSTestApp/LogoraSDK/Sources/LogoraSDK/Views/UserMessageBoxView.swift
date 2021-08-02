
import UIKit
import Kingfisher

class UserMessageBoxView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var debateTitle: UILabel!
    @IBOutlet weak var participantsCount: UILabel!
    @IBOutlet weak var argumentsCount: UILabel!
    @IBOutlet weak var winningThesis: UILabel!
    @IBOutlet weak var argumentContainer: UIView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userFullName: UILabel!
    @IBOutlet weak var argumentSide: UILabel!
    @IBOutlet weak var argumentSideContainer: UIView!
    @IBOutlet weak var userLevel: UILabel!
    @IBOutlet weak var userLevelIcon: UIImageView!
    @IBOutlet weak var argumentContent: UILabel!
    @IBOutlet weak var argumentClap: UIButton!
    @IBOutlet weak var argumentReplyButton: UIButton!
    @IBOutlet weak var argumentShareButton: UIButton!
    var message: Message! {
        didSet {
            contentView.addBorder(hexString: SettingsProvider.sharedInstance.getTheme(key: "borderBoxColor"), width: 0.2)
            contentView.addShadow(offset: CGSize.init(width: 0, height: 1), color: UIColor.init(hexString: SettingsProvider.sharedInstance.getTheme(key: "borderBoxColor")), radius: 5, opacity: 0.35)
            argumentContainer.addBorder(hexString: SettingsProvider.sharedInstance.getTheme(key: "borderBoxColor"), width: 0.2)
//            argumentSide.textColor = UIColor.white
//            argumentSide.sizeToFit()
//            argumentSideContainer.roundCorners([.bottomLeft, .topRight], radius: 6)
//            if message.isPro {
//                argumentSideContainer.backgroundColor = UIColor.init(hexString: SettingsProvider.sharedInstance.getTheme(key: "forPrimaryColor"))
//            } else {
//                argumentSideContainer.backgroundColor = UIColor.init(hexString: SettingsProvider.sharedInstance.getTheme(key: "againstPrimaryColor"))
//            }
//            argumentSide.text = message.position.name
            winningThesis.text = getWinningThesis(votesCountObj: message.group!.votesCount, positions: message.group!.groupContext.positions)
            debateTitle.text = message.group?.name
            userImage.kf.setImage(with: URL(string: (message.author.imageURL)!))
            userImage.makeRounded()
            argumentContent.text = message.content
            argumentContent.numberOfLines = 0
            argumentsCount.textColor = .systemGray
            participantsCount.textColor = .systemGray
            argumentsCount.text = String(message.group?.messagesCount ?? 0)
            participantsCount.text = String(message.group!.participantsCount)
            userFullName.text = message.author.fullName
            userLevel.text = UtilsProvider.getLocalizedString(textKey: "user_box_level") + " \(String(describing: message.author.level?.id))"
            userLevelIcon.kf.setImage(with: URL(string: (message.author.level?.iconURL)!))
        }
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    func commonInit(){
        let bundle = Bundle(for: Self.self)
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        nib.instantiate(withOwner: self, options: nil)

        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    func getWinningThesis(votesCountObj: [String: String], positions: [Position]) -> String {
        var winningId: Int?
        var maxValue = 0
        var winningPosition: Position = positions[0]
        for (key, value) in votesCountObj {
            if key != "total" {
                if Int(value)! >= maxValue {
                    maxValue = Int(value)!
                    winningId = Int(key)
                    winningPosition = positions.filter { position in
                        return position.id == winningId
                    }[0]
                }
            }
        }
        return "\(maxValue) % \(String(describing: winningPosition.name))"
    }
}
