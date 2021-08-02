import UIKit
import Kingfisher

class ArgumentBoxView: UIView {
    var apiClient = APIClient.sharedInstance
    var repliesOpen: Bool = false
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userFullName: UILabel!
    @IBOutlet weak var userLevel: UILabel!
    @IBOutlet weak var userLevelIcon: UIImageView!
    @IBOutlet weak var messageContent: UILabel!
    @IBOutlet weak var messageClapBtn: UIButton!
    @IBOutlet weak var messageReplyBtn: UIButton!
    @IBOutlet weak var messageShareBtn: UIButton!
    @IBOutlet weak var messageMoreBtn: UIButton!
    @IBOutlet weak var repliesContainer: UIStackView!
    @IBOutlet weak var showRepliesBtn: UIButton!
    @IBOutlet weak var replyFirstAuthor: UIImageView!
    @IBOutlet weak var replySecondAuthor: UIImageView!
    @IBOutlet weak var replyThirdAuthor: UIImageView!
    @IBOutlet weak var repliesSeparatorLine: UIView!
    
    var message: Message! {
        didSet {
            contentView.addBorder(hexString: SettingsProvider.sharedInstance.getTheme(key: "borderBoxColor"), width: 0.2)
            contentView.addShadow(offset: CGSize.init(width: 0, height: 1), color: UIColor.init(hexString: SettingsProvider.sharedInstance.getTheme(key: "borderBoxColor")), radius: 5, opacity: 0.35)
            userImage.kf.setImage(with: URL(string: message.author.imageURL!))
            userImage.makeRounded()
            userLevelIcon.kf.setImage(with: URL(string: message.author.level!.iconURL))
            userFullName.font = UIFont.boldSystemFont(ofSize: userFullName.font.pointSize)
            userFullName.text = message.author.fullName
            userLevel.text = UtilsProvider.getLocalizedString(textKey: "user_box_level") + " \(String(describing: message.author.level!.id))"
            messageContent.text = message.content
            messageContent.numberOfLines = 0
            // Replies
            if message.numberReplies! > 0 {
                repliesSeparatorLine.isHidden = false
                showRepliesBtn.setTitle("Voir \(String(describing: message.numberReplies)) réponses", for: .normal)
            } else {
                repliesSeparatorLine.isHidden = true
                showRepliesBtn.setTitle("", for: .normal)
            }
            replyFirstAuthor.isHidden = true
            replySecondAuthor.isHidden = true
            replyThirdAuthor.isHidden = true
            let participants = message.repliesAuthors!.prefix(3)
            if participants.isEmpty {
                repliesContainer.isHidden = true
            } else {
                repliesContainer.isHidden = false
                participants.enumerated().forEach { (index, participant) in
                    let imageUrl = URL(string: participant.authorImage)
                    switch index {
                        case 0:
                            replyFirstAuthor.isHidden = false
                            replyFirstAuthor.makeRounded()
                            replyFirstAuthor.kf.setImage(with: imageUrl)
                        case 1:
                            replySecondAuthor.isHidden = false
                            replySecondAuthor.makeRounded()
                            replySecondAuthor.kf.setImage(with: imageUrl)
                        case 2:
                            replyThirdAuthor.isHidden = false
                            replyThirdAuthor.makeRounded()
                            replyThirdAuthor.kf.setImage(with: imageUrl)
                        default:
                            return
                    }
                }
            }
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
    
    @IBAction func showArgumentReplies(_ sender: Any) {
        self.toggleReplies(show: true)
    }
    
    func getReplies() {
        //apiClient.getReplies(argumentId: String(self.message.id), sort: "-created_at", perPage: 5, page: 1, completion: { replies in
        //    print(replies)
        //})
    }
    
    func toggleReplies(show: Bool) {
        self.repliesOpen = show
        switch repliesOpen {
        case true:
            self.getReplies()
        case false:
            print("close")
        }
    }
}

