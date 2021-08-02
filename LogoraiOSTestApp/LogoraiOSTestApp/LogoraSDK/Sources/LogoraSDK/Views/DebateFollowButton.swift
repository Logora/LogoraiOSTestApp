import UIKit

class DebateFollowButton: UIButton {
    let settings: SettingsProvider = SettingsProvider.sharedInstance
    let apiClient: APIClient = APIClient.sharedInstance
    let authService: AuthService = AuthService.sharedInstance
    private var debate: Debate?
    private var active: Bool = false
    private var container: UIView! = UIView()
    private var content: UILabel! = UILabel()
    
    required init() {
        super.init(frame: .zero)

        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }

    func setup() {
        self.isUserInteractionEnabled = true
        self.container.isUserInteractionEnabled = true
        self.content.isUserInteractionEnabled = true
        self.setInactive();
        self.addSubview(container)
        self.container.addSubview(content)
        
        self.container.addBorder(hexString: SettingsProvider.sharedInstance.get(key: "theme.callPrimaryColor"), width: 2)
        self.container.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.left.right.equalTo(self)
            make.bottom.equalTo(self)
        }
        
        self.content.setToBold()
        self.content.snp.makeConstraints { (make) in
            make.right.left.equalTo(self.container).inset(15)
            make.top.bottom.equalTo(self.container).inset(5)
        }
    }

    func setActive() {
        self.active = true
        self.content.text = "SUIVI"
        self.content.textColor = UIColor.white
        self.container.backgroundColor = UIColor.init(hexString: SettingsProvider.sharedInstance.get(key: "theme.callPrimaryColor"))
        self.initActions()
    }

    func setInactive() {
        self.active = false
        self.content.text = "SUIVRE"
        self.content.textColor = UIColor.init(hexString: SettingsProvider.sharedInstance.get(key: "theme.callPrimaryColor"))
        self.container.backgroundColor = UIColor.white
        self.initActions()
    }

    func follow(clickedObject: Any?) {
        self.setActive()
        self.apiClient.followDebate(debateSlug: self.debate!.slug!, completion: { debate in
            DispatchQueue.main.async {
            }
        })
    }

    func unfollow(clickedObject: Any?) {
        self.setInactive()
        self.apiClient.unfollowDebate(debateSlug: self.debate!.slug!, completion: { debate in
            DispatchQueue.main.async {
            }
        })
    }

    func initView(debate: Debate) {
        self.debate = debate
        if(self.authService.getLoggedIn()) {
            self.apiClient.getDebateFollow(debateId: self.debate!.id, completion: { debateFollowing in
                DispatchQueue.main.async {
                    if(debateFollowing.follow == true) {
                        self.setActive()
                    }
                }
            })
        }
    }
    
    func initActions() {
        if(self.active == true) {
            self.content.setOnClickListener(action: unfollow, clickedObject: nil)
        } else {
            self.content.setOnClickListener(action: follow, clickedObject: nil)
        }
    }
}
