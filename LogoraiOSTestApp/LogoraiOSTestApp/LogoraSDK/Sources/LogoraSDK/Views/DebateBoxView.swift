import UIKit
import Kingfisher

class DebateBoxView: UITableViewCell, CellElement {
    let router = Router.sharedInstance
    @IBOutlet weak var debateBoxImage: UIImageView!
    @IBOutlet weak var debateBoxTitle: UILabel!
    @IBOutlet weak var debateBoxFirstParticipant: UIImageView!
    @IBOutlet weak var debateBoxSecondParticipant: UIImageView!
    @IBOutlet weak var debateBoxThirdParticipant: UIImageView!
    @IBOutlet weak var debateBoxMoreParticipants: UILabel!
    @IBOutlet weak var debateBoxWinningThesis: UILabel!
    @IBOutlet weak var noParticipantsLabel: UILabel!
    
    private var debate: Debate!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let containerView = loadViewFromNib()
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(contentView)
        }
        self.contentView.frame = containerView.frame
        self.frame = containerView.frame
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
    
    
    func setResource(resource: Codable) {
        let debate = resource as! Debate
        self.debate = debate
        configure()
    }
    
    func getHeight() -> CGFloat {
        return self.frame.height
    }

    func configure() {
        self.isUserInteractionEnabled = true
        self.debateBoxImage.isUserInteractionEnabled = true
        self.debateBoxImage.setOnClickListener(action: debateTap, clickedObject: nil)
        contentView.addBorder(hexString: SettingsProvider.sharedInstance.getTheme(key: "borderBoxColor"), width: 0.2)
        contentView.addShadow(offset: CGSize.init(width: 0, height: 1), color: UIColor.init(hexString: SettingsProvider.sharedInstance.getTheme(key: "borderBoxColor")), radius: 5, opacity: 0.35)
        debateBoxImage.kf.setImage(with: URL(string: debate.imageURL))
        debateBoxImage?.clipsToBounds = true
        debateBoxImage?.roundCorners([.topLeft, .topRight], radius: 6)
        debateBoxFirstParticipant.makeRounded()
        debateBoxSecondParticipant.makeRounded()
        debateBoxThirdParticipant.makeRounded()
        debateBoxTitle.text = debate.name
        debateBoxTitle.font = UIFont.boldSystemFont(ofSize: 20.0)
        debateBoxTitle.numberOfLines = 0
        debateBoxWinningThesis.text = self.getWinningThesis(votesCountObj: debate.votesCount, positions: debate.groupContext.positions)
        
        // Participants
        debateBoxFirstParticipant.isHidden = true
        debateBoxSecondParticipant.isHidden = true
        debateBoxThirdParticipant.isHidden = true
        if debate.participantsCount > 3 {
            debateBoxMoreParticipants.isHidden = false
            debateBoxMoreParticipants.text = "+ \(debate.participantsCount - 3)"
            debateBoxMoreParticipants.layer.masksToBounds = true
            debateBoxMoreParticipants.clipsToBounds = true
            debateBoxMoreParticipants.layer.cornerRadius = 20
        } else {
            debateBoxMoreParticipants.isHidden = true
        }

        let participants = debate.participants?.prefix(3)
        if participants?.count == 0 {
            noParticipantsLabel.text = UtilsProvider.getLocalizedString(textKey: "debate_box_user_list_empty")
            noParticipantsLabel.isHidden = false
            noParticipantsLabel.font = UIFont.italicSystemFont(ofSize: 14.0)
        } else {
            noParticipantsLabel.isHidden = true
            participants?.enumerated().forEach { (index, participant) in
                let imageUrl = URL(string: participant.imageURL!)
                let slug = participant.slug
                switch index {
                    case 0:
                        debateBoxFirstParticipant.isHidden = false
                        debateBoxFirstParticipant.makeRounded()
                        debateBoxFirstParticipant.kf.setImage(with: imageUrl)
                        debateBoxFirstParticipant.isUserInteractionEnabled = true
                        debateBoxFirstParticipant.setOnClickListener(action: participantTap, clickedObject: slug)
                    case 1:
                        debateBoxSecondParticipant.isHidden = false
                        debateBoxSecondParticipant.makeRounded()
                        debateBoxSecondParticipant.kf.setImage(with: imageUrl)
                        debateBoxSecondParticipant.isUserInteractionEnabled = true
                        debateBoxSecondParticipant.setOnClickListener(action: participantTap, clickedObject: slug)
                    case 2:
                        debateBoxThirdParticipant.isHidden = false
                        debateBoxThirdParticipant.makeRounded()
                        debateBoxThirdParticipant.kf.setImage(with: imageUrl)
                        debateBoxThirdParticipant.isUserInteractionEnabled = true
                        debateBoxThirdParticipant.setOnClickListener(action: participantTap, clickedObject: slug)
                    default:
                        return
                }
            }
        }
    }
    
    func debateTap(clickedObject: Any?) {
        router.setRoute(routeName: "DEBATE", routeParam: self.debate.slug!)
    }
    
    func participantTap(clickedObject: Any?) {
        router.setRoute(routeName: "USER", routeParam: clickedObject as! String)
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
        return "\(maxValue) % \(winningPosition.name!))"
    }
}
