import UIKit
import SnapKit

class ArgumentVote: UIView {
    private final var auth = AuthService.sharedInstance
    private final var apiClient = APIClient.sharedInstance
    private var argument: Message!
    private var argumentVoteImage: UIImageView! = UIImageView()
    private var argumentVoteCount: UILabel! = UILabel()
    private var hasVoted: Bool!
    private var votesCount: Int!
    private var voteId: Int!
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup(argument: Message) {
        self.argument = argument
        initLayout()
        initActions()
        initHasVoted()
    }
    
    func initLayout() {
        self.addSubview(self.argumentVoteImage)
        self.addSubview(self.argumentVoteCount)
        
        self.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self)
            make.left.right.leading.trailing.equalTo(self)
            make.height.equalTo(28)
        }
        
        if #available(iOS 13.0, *) {
            self.argumentVoteImage.image = UIImage(named: "clap", in: Bundle(for: type(of: self)), with: nil)
        }
        self.argumentVoteImage.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(28).priority(.required)
            make.centerY.equalTo(self.snp.centerY)
        }
        
        self.argumentVoteCount.text = String(self.argument.upvotes)
        self.argumentVoteCount.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(self.argumentVoteImage.snp.right).offset(5)
            make.centerY.equalTo(self.snp.centerY)
        }
    }
    
    func initHasVoted() {
        self.setInactive();
        if (auth.getLoggedIn() == true) {
            let currentUserId = auth.currentUser?.id
            if(argument.getHasUserVoted(userId: currentUserId!)) {
                self.hasVoted = true
                self.voteId = argument.getUserVoteId(userId: currentUserId!)
                setActive()
            }
        }
    }
    
    func initActions() {
        self.isUserInteractionEnabled = true
        self.argumentVoteImage.isUserInteractionEnabled = true
        self.argumentVoteCount.isUserInteractionEnabled = true
        self.setOnClickListener(action: toggleVote, clickedObject: nil)
    }
    
    func setInactive() {
        self.argumentVoteImage.image = self.argumentVoteImage.image?.withRenderingMode(.alwaysTemplate)
        self.argumentVoteImage.tintColor = UIColor.black
        self.argumentVoteCount.text = String(self.argument.upvotes)
        self.argumentVoteCount.textColor = UIColor.black
    }
    
    func setActive() {
        let positionIndex = self.argument.group?.getPositionIndex(index: self.argument.position.id)
        if (positionIndex == 0) {
            self.argumentVoteImage.image = self.argumentVoteImage.image?.withRenderingMode(.alwaysTemplate)
            self.argumentVoteImage.tintColor = UIColor.init(hexString: SettingsProvider.sharedInstance.get(key: "theme.forPrimaryColor"))
            self.argumentVoteCount.textColor = UIColor.init(hexString: SettingsProvider.sharedInstance.get(key: "theme.forPrimaryColor"))
        } else {
            self.argumentVoteImage.image = self.argumentVoteImage.image?.withRenderingMode(.alwaysTemplate)
            self.argumentVoteImage.tintColor = UIColor.init(hexString: SettingsProvider.sharedInstance.get(key: "theme.againstPrimaryColor"))
            self.argumentVoteCount.textColor = UIColor.init(hexString: SettingsProvider.sharedInstance.get(key: "theme.againstPrimaryColor"))
        }
    }
    
    func toggleVote(clickedObject: Any?) {
        if (auth.getLoggedIn() == true) {
            if (self.hasVoted) {
                self.votesCount = self.argument.upvotes - 1
                self.argumentVoteCount.text = String(self.votesCount)
                self.apiClient.deleteVote(voteId: self.voteId, completion: { vote in
                    DispatchQueue.main.async {
                        self.setInactive()
                    }
                })
            } else {
                self.votesCount = self.argument.upvotes + 1
                self.argumentVoteCount.text = String(self.votesCount)
                self.apiClient.createVote(voteableId: String(self.voteId), voteableType: "Message", completion: { vote in
                    DispatchQueue.main.async {
                        self.voteId = vote.id
                        self.setActive()
                    }
                })
            }
        } else {
            let modalView = LoginModal()
            let modalViewController = ModalViewController(modalView: modalView, modalHeight: 400, modalWidth: 300)
            self.parentViewController!.present(modalViewController, animated: true, completion: nil)
        }
    }
    
}
