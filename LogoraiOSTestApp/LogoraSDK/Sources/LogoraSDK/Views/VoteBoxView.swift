import UIKit

class VoteBoxView: UIView {
    private let settings: SettingsProvider = SettingsProvider.sharedInstance
    private let apiClient: APIClient = APIClient.sharedInstance
    private let authService: AuthService = AuthService.sharedInstance
    var debate: Debate!
    var votesPercentages: [String: Double]!
    var voteId: Int! = nil
    var votePositionId: Int! = nil
    var firstPositionPercentage: Int!
    var secondPositionPercentage: Int!
    var firstPositionId: String!
    var secondPositionId: String!
    private var voteBoxProThesisButton: UIButton! = UIButton()
    private var voteBoxProThesis: UILabel! = UILabel()
    private var voteBoxProThesisPercentage: UILabel! = UILabel()
    private var voteBoxProThesisProgress: UIProgressView! = UIProgressView()
    private var voteBoxAgainstThesisButton: UIButton! = UIButton()
    private var voteBoxAgainstThesis: UILabel! = UILabel()
    private var voteBoxAgainstThesisPercentage: UILabel! = UILabel()
    private var voteBoxAgainstThesisProgress: UIProgressView! = UIProgressView()
    private var voteBoxTotalVotes: UILabel! = UILabel()
    private var updateVoteButton: UILabel! = UILabel()
    private var voteBoxProThesisContainer: UIStackView! = UIStackView()
    private var voteBoxAgainstThesisContainer: UIStackView! = UIStackView()
    private var separator: UIView! = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup(debate: Debate){
        self.debate = debate
        self.votesPercentages = debate.getVotePercentages()
        self.firstPositionId = String((self.debate?.groupContext.positions[0].id)!)
        self.secondPositionId = String((self.debate?.groupContext.positions[1].id)!)
        self.firstPositionPercentage = Int(votesPercentages[String((self.debate?.groupContext.positions[0].id)!)]!)
        self.secondPositionPercentage = Int(votesPercentages[String((self.debate?.groupContext.positions[1].id)!)]!)
        if(authService.getLoggedIn() == true) {
            self.apiClient.getDebateVote(id: debate.id, completion: { vote in
                print("VOTE", vote)
                DispatchQueue.main.async {
                    if (vote.vote == true) {
                        self.voteId = vote.resource?.id
                        self.votePositionId = vote.resource?.positionId
                        self.initResults()
                    } else {
                        self.initButtons()
                    }
                }
            })
        } else {
            initButtons()
        }
        initActions()
    }
    
    func initButtons() {
        self.addSubview(voteBoxProThesisButton)
        self.addSubview(voteBoxAgainstThesisButton)
        self.addSubview(voteBoxTotalVotes)
        self.addSubview(separator)
        
        self.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self)
            make.left.right.leading.trailing.equalTo(self)
            make.bottom.equalTo(self.separator.snp.bottom)
        }
        
        self.voteBoxProThesisButton.setTitle(debate?.groupContext.positions[0].name, for: .normal)
        self.voteBoxProThesisButton.layer.borderWidth = 0.6
        self.voteBoxProThesisButton.layer.cornerRadius = 6
        self.voteBoxProThesisButton.titleLabel?.setToSubtitle()
        self.voteBoxProThesisButton.titleLabel?.setToBold()
        self.voteBoxProThesisButton.uppercased()
        self.voteBoxProThesisButton.tintColor = UIColor.white
        self.voteBoxProThesisButton.addShadow(offset: CGSize.init(width: 0, height: 1), color: UIColor.init(hexString: SettingsProvider.sharedInstance.getTheme(key: "borderBoxColor")), radius: 4, opacity: 0.35)
        self.voteBoxProThesisButton.layer.borderColor = UIColor.init(hexString: SettingsProvider.sharedInstance.get(key: "theme.forPrimaryColor")).cgColor
        self.voteBoxProThesisButton.backgroundColor = UIColor.init(hexString: SettingsProvider.sharedInstance.get(key: "theme.forPrimaryColor"))
        self.voteBoxProThesisButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self)
            make.left.equalTo(self).offset(50)
            make.right.equalTo(self).offset(-50)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        self.voteBoxAgainstThesisButton.setTitle(debate?.groupContext.positions[1].name, for: .normal)
        self.voteBoxAgainstThesisButton.layer.borderWidth = 0.6
        self.voteBoxAgainstThesisButton.layer.cornerRadius = 6
        self.voteBoxAgainstThesisButton.titleLabel?.setToSubtitle()
        self.voteBoxAgainstThesisButton.titleLabel?.setToBold()
        self.voteBoxAgainstThesisButton.uppercased()
        self.voteBoxAgainstThesisButton.tintColor = UIColor.white
        self.voteBoxAgainstThesisButton.addShadow(offset: CGSize.init(width: 0, height: 1), color: UIColor.init(hexString: SettingsProvider.sharedInstance.getTheme(key: "borderBoxColor")), radius: 4, opacity: 0.35)
        self.voteBoxAgainstThesisButton.layer.borderColor = UIColor.init(hexString: SettingsProvider.sharedInstance.get(key: "theme.againstPrimaryColor")).cgColor
        self.voteBoxAgainstThesisButton.backgroundColor = UIColor.init(hexString: SettingsProvider.sharedInstance.get(key: "theme.againstPrimaryColor"))
        self.voteBoxAgainstThesisButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.voteBoxProThesisButton.snp.bottom).offset(10)
            make.left.equalTo(self).offset(50)
            make.right.equalTo(self).offset(-50)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        self.voteBoxTotalVotes.text = "\(debate?.votesCount["total"] ?? "0") votes"
        self.voteBoxTotalVotes.setToSecondaryText()
        self.voteBoxTotalVotes.setToSecondaryTextColor()
        self.voteBoxTotalVotes.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.voteBoxAgainstThesisButton.snp.bottom).offset(15)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        self.separator.backgroundColor = UIColor.init(hexString: SettingsProvider.sharedInstance.getTheme(key: "borderBoxColor"))
        self.separator.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.voteBoxTotalVotes.snp.bottom).offset(15)
            make.left.leading.equalTo(self)
            make.height.equalTo(0.3)
            make.width.equalTo(self.snp.width)
        }
    }
    
    func initResults() {
        self.addSubview(voteBoxProThesis)
        self.addSubview(voteBoxProThesisProgress)
        self.addSubview(voteBoxProThesisPercentage)
        self.addSubview(voteBoxAgainstThesis)
        self.addSubview(voteBoxAgainstThesisProgress)
        self.addSubview(voteBoxAgainstThesisPercentage)
        self.addSubview(voteBoxTotalVotes)
        self.addSubview(updateVoteButton)
        self.addSubview(separator)
        
        self.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self)
            make.left.right.leading.trailing.equalTo(self)
            make.bottom.equalTo(self.separator.snp.bottom)
        }
        
        self.voteBoxProThesis.text = self.debate?.groupContext.positions[0].name
        self.voteBoxProThesis.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(self)
            make.left.equalTo(self)
        }
        
        self.voteBoxProThesisProgress.layer.cornerRadius = 15
        self.voteBoxProThesisProgress.clipsToBounds = true
        self.voteBoxProThesisProgress.layer.sublayers![1].cornerRadius = 15
        self.voteBoxProThesisProgress.subviews[1].clipsToBounds = true
        self.voteBoxProThesisProgress.progress = 0
        self.voteBoxProThesisProgress.tintColor = UIColor.init(hexString: SettingsProvider.sharedInstance.get(key: "theme.forPrimaryColor"))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.voteBoxProThesisProgress.setProgress(Float(Double(self.firstPositionPercentage) / 100), animated: true)
        }
        self.voteBoxProThesisProgress.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(self.voteBoxProThesis.snp.bottom).offset(5)
            make.left.right.equalTo(self).priority(.required)
            make.height.equalTo(30)
        }
        
        self.voteBoxProThesisPercentage.text = "\(self.firstPositionPercentage!) %"
        self.voteBoxProThesisPercentage.textColor = UIColor.white
        self.voteBoxProThesisPercentage.setToBold()
        self.voteBoxProThesisPercentage.snp.makeConstraints{ (make) -> Void in
            make.centerY.equalTo(self.voteBoxProThesisProgress)
            make.left.equalTo(self.voteBoxProThesisProgress).offset(10)
        }
        
        self.voteBoxAgainstThesis.text = self.debate?.groupContext.positions[1].name
        self.voteBoxAgainstThesis.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(self.voteBoxProThesisProgress.snp.bottom).offset(10)
            make.left.equalTo(self)
        }
        
        self.voteBoxAgainstThesisProgress.layer.cornerRadius = 15
        self.voteBoxAgainstThesisProgress.clipsToBounds = true
        self.voteBoxAgainstThesisProgress.layer.sublayers![1].cornerRadius = 15
        self.voteBoxAgainstThesisProgress.subviews[1].clipsToBounds = true
        self.voteBoxAgainstThesisProgress.progress = 0
        self.voteBoxAgainstThesisProgress.tintColor = UIColor.init(hexString: SettingsProvider.sharedInstance.get(key: "theme.againstPrimaryColor"))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.voteBoxAgainstThesisProgress.setProgress(Float(Double(self.secondPositionPercentage) / 100), animated: true)
        }
        self.voteBoxAgainstThesisProgress.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(self.voteBoxAgainstThesis.snp.bottom).offset(5)
            make.left.right.equalTo(self).priority(.required)
            make.height.equalTo(30)
        }
        
        self.voteBoxAgainstThesisPercentage.text = "\(self.secondPositionPercentage!) %"
        self.voteBoxAgainstThesisPercentage.textColor = UIColor.white
        self.voteBoxAgainstThesisPercentage.setToBold()
        self.voteBoxAgainstThesisPercentage.snp.makeConstraints{ (make) -> Void in
            make.centerY.equalTo(self.voteBoxAgainstThesisProgress)
            make.left.equalTo(self.voteBoxAgainstThesisProgress).offset(10)
        }
        
        self.voteBoxTotalVotes.text = "\(debate?.votesCount["total"] ?? "0") votes"
        self.voteBoxTotalVotes.setToSecondaryText()
        self.voteBoxTotalVotes.setToSecondaryTextColor()
        self.voteBoxTotalVotes.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(self.voteBoxAgainstThesisProgress.snp.bottom).offset(15)
            make.left.equalTo(self)
        }
        
        self.updateVoteButton.text = "Modifier"
        self.updateVoteButton.setToSecondaryText()
        self.updateVoteButton.setToSecondaryTextColor()
        self.updateVoteButton.underline()
        self.updateVoteButton.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(self.voteBoxAgainstThesisProgress.snp.bottom).offset(15)
            make.right.equalTo(self)
        }
        
        self.separator.backgroundColor = UIColor.init(hexString: SettingsProvider.sharedInstance.getTheme(key: "borderBoxColor"))
        self.separator.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.voteBoxTotalVotes.snp.bottom).offset(15)
            make.left.leading.equalTo(self)
            make.height.equalTo(0.3)
            make.width.equalTo(self.snp.width)
        }
    }
    
    func initActions() {
        updateVoteButton.isUserInteractionEnabled = true
        updateVoteButton.setOnClickListener(action: showButtons, clickedObject: nil)
        voteBoxProThesisButton.setOnClickListener(action: vote, clickedObject: firstPositionId)
        voteBoxAgainstThesisButton.setOnClickListener(action: vote, clickedObject: secondPositionId)
    }
    
    func showButtons(clickedObject: Any?) {
        self.toggleResults(active: false)
    }
    
    func vote(clickedObject: Any?) {
        print("VOTE")
        if(self.votePositionId != nil) {
            print("VOTE -> UPDATE VOTE")
            if (clickedObject as? Int != self.votePositionId) {
                debate.calculateVotePercentage(positionId: (clickedObject as? String)!, isUpdate: true)
            }
            if (clickedObject as? Int != self.votePositionId) {
                self.updateVote(positionId: clickedObject as! String);
            }
        } else {
            print("VOTE -> CREATEVOTE")
            debate.calculateVotePercentage(positionId: (clickedObject as? String)!, isUpdate: true)
            self.createVote(positionId: clickedObject as! String);
        }
    }
    
    func updateVote(positionId: String) {
        self.apiClient.updateVote(voteId: self.voteId, positionId: Int(positionId), completion: { vote in
            print("UPDATE VOTE COMPLETION", vote)
              DispatchQueue.main.async {
                  self.voteId = vote.id
                  self.votePositionId = vote.positionId
              }
        })
        self.toggleResults(active: true)
    }
    
    func createVote(positionId: String) {
        self.apiClient.createVote(voteableId: String(self.debate.id), voteableType: "Group", positionId: Int(positionId), completion: { vote in
            DispatchQueue.main.async {
                print("CREATE VOTE", vote)
                self.voteId = vote.id
                self.votePositionId = vote.positionId
                print("VOTE POSITION ID", self.votePositionId)
            }
        })
        self.toggleResults(active: true)
    }
    
    func toggleResults(active: Bool) {
        switch(active){
            case true:
                self.voteBoxProThesisButton.removeFromSuperview()
                self.voteBoxAgainstThesisButton.removeFromSuperview()
                self.voteBoxTotalVotes.removeFromSuperview()
                self.separator.removeFromSuperview()
                self.initResults()
            case false:
                self.voteBoxProThesis.removeFromSuperview()
                self.voteBoxProThesisProgress.removeFromSuperview()
                self.voteBoxProThesisPercentage.removeFromSuperview()
                self.voteBoxAgainstThesis.removeFromSuperview()
                self.voteBoxAgainstThesisProgress.removeFromSuperview()
                self.voteBoxAgainstThesisPercentage.removeFromSuperview()
                self.voteBoxTotalVotes.removeFromSuperview()
                self.updateVoteButton.removeFromSuperview()
                self.separator.removeFromSuperview()
                self.initButtons()
        }
    }
    
    
}
