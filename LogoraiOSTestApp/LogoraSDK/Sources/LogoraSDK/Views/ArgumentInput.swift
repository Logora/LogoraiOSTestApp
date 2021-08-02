import UIKit
import SnapKit

class ArgumentInput: UIView, UITextViewDelegate, ArgumentInputListener {
    private final var inputProvider = InputProvider.sharedInstance
    private final var router = Router.sharedInstance
    private final var auth = AuthService.sharedInstance
    private final var apiClient = APIClient.sharedInstance
    var debate: Debate!
    var inputContainer: UIView! = UIView()
    var argumentAuthorBox: ArgumentAuthorBox! = ArgumentAuthorBox()
    var textInput: UITextView! = UITextView()
    var sendButton: UIButton! = UIButton()
    
    weak var listener: AddElementToListListener? = nil
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup(debate: Debate) {
        self.debate = debate
        self.textInput.delegate = self
        if (auth.getLoggedIn() == true) {
            let author = auth.getCurrentUser()
            self.argumentAuthorBox.setup(isInput: true, author: author, defaultAuthor: nil, isDefaultAuthor: false)
        } else {
            let author = DefaultAuthor()
            self.argumentAuthorBox.setup(isInput: true, author: nil, defaultAuthor: author, isDefaultAuthor: true)
        }
        initLayout()
    }
    
    func initLayout() {
        self.addSubview(inputContainer)
        self.addSubview(argumentAuthorBox)
        self.addSubview(textInput)
        self.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self)
            make.left.right.leading.trailing.equalTo(self)
            make.bottom.equalTo(self.inputContainer.snp.bottom).offset(15)
        }
        
        self.inputContainer.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self)
            make.left.right.leading.trailing.equalTo(self)
            make.bottom.equalTo(self.textInput.snp.bottom)
        }
        
        self.argumentAuthorBox.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.inputContainer)
            make.left.right.leading.trailing.equalTo(self.inputContainer)
        }
        
        self.textInput.text = "Ajouter un argument..."
        self.textInput.textColor = UIColor.lightGray
        self.textInput.font = UIFont.systemFont(ofSize: 17.0)
        self.textInput.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.argumentAuthorBox.snp.bottom).offset(15)
            make.left.right.leading.trailing.equalTo(self.inputContainer)
            make.height.equalTo(40)
        }
        
        initActions()
    }
    
    func textViewDidBeginEditing(_ textField: UITextView) {
        if (auth.getLoggedIn() == true) {
            if textInput.textColor == UIColor.lightGray {
                textInput.text = ""
                textInput.textColor = UIColor.black
            }
            self.addSubview(sendButton)
            
            self.sendButton.layer.borderWidth = 0.6
            self.sendButton.layer.cornerRadius = 6
            self.sendButton.titleLabel?.setToSubtitle()
            self.sendButton.titleLabel?.setToBold()
            self.sendButton.uppercased()
            self.sendButton.addShadow(offset: CGSize.init(width: 0, height: 1), color: UIColor.init(hexString: SettingsProvider.sharedInstance.getTheme(key: "borderBoxColor")), radius: 4, opacity: 0.35)
            self.sendButton.layer.borderColor = UIColor.init(hexString: SettingsProvider.sharedInstance.get(key: "theme.callPrimaryColor")).cgColor
            self.sendButton.backgroundColor = UIColor.init(hexString: SettingsProvider.sharedInstance.get(key: "theme.callPrimaryColor"))
            if #available(iOS 13.0, *) {
                let origImage = UIImage(named: "send_message", in: Bundle(for: type(of: self)), with: nil)
                let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
                self.sendButton.setImage(tintedImage, for: .normal)
                self.sendButton.tintColor = .white
            }
            self.sendButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
            self.sendButton.snp.makeConstraints { (make) -> Void in
                make.height.equalTo(36)
                make.top.equalTo(self.textInput.snp.bottom).priority(.required)
                make.right.equalTo(self.inputContainer)
            }
            
            self.sendButton.imageView?.snp.makeConstraints { (make) -> Void in
                make.width.height.equalTo(20)
                make.centerX.centerY.equalTo(self.sendButton)
            }
            
            self.inputContainer.snp.remakeConstraints { (make) -> Void in
                make.top.equalTo(self)
                make.left.right.leading.trailing.equalTo(self)
                make.bottom.equalTo(self.sendButton.snp.bottom)
            }
        } else {
            self.textInput.endEditing(true)
            self.textInput.resignFirstResponder()
            self.textInput.tintColor = UIColor.clear
            let modalView = LoginModal()
            let modalViewController = ModalViewController(modalView: modalView, modalHeight: 400, modalWidth: 300)
            self.parentViewController!.present(modalViewController, animated: true, completion: nil)
        }
    }
    
    
    func initActions() {
        self.sendButton.setOnClickListener(action: addArgument)
    }
    
    func addArgument(clickedObject: Any?) {
        if (inputProvider.getUpdateArgument() != nil) {
            self.updateArgument(argument: inputProvider.getUpdateArgument()!)
        } else {
            self.createArgument(positionId: nil);
        }
    }
    
    func updateArgument(argument: Message) {
        listener?.removeElementFromList(element: argument)
        self.apiClient.updateArgument(argumentId: argument.id, argumentContent: self.textInput.text, completion: { argument in
            DispatchQueue.main.async {
                self.listener?.addElementToList(element: argument)
                self.textInput.text = ""
                self.inputProvider.removeUpdateArgument();
                Toast.show(message: "Argument modifié avec succès", controller: self.parentViewController!)
            }
        })
    }
    
    func createArgument(positionId: Int?) {
        if (auth.getLoggedIn() == true) {
            if (positionId != nil) {
                self.apiClient.createArgument(debateId: self.debate.id, argumentContent: self.textInput.text, positionId: positionId, isReply: false, completion: { argument in
                    DispatchQueue.main.async {
                        self.listener!.addElementToList(element: argument)
                        self.inputProvider.removeUserPosition(id: self.debate.id)
                        self.textInput.text = ""
                        Toast.show(message: "Votre argument à été créé avec succès", controller: self.parentViewController!)
                    }
                })
            } else {
                if (inputProvider.getUserPositions()[self.debate.id] != nil) {
                    self.apiClient.createArgument(debateId: self.debate.id, argumentContent: self.textInput.text, positionId: inputProvider.getUserPositions()[self.debate.id], isReply: false, completion: { argument in
                        DispatchQueue.main.async {
                            self.listener!.addElementToList(element: argument)
                            self.inputProvider.removeUserPosition(id: self.debate.id)
                            self.textInput.text = ""
                            Toast.show(message: "Votre argument à été créé avec succès", controller: self.parentViewController!)
                        }
                    })
                } else {
                    let modalView = SideModal()
                    modalView.listener = self
                    modalView.setup(debate: self.debate)
                    let modalViewController = ModalViewController(modalView: modalView, modalHeight: 150, modalWidth: 300)
                    self.parentViewController!.present(modalViewController, animated: true, completion: nil)
                }
            }
        } else {
            let modalView = LoginModal()
            let modalViewController = ModalViewController(modalView: modalView, modalHeight: 400, modalWidth: 300)
            self.parentViewController!.present(modalViewController, animated: true, completion: nil)
        }
    }
    
    func onArgumentReady(positionId: Int) {
        createArgument(positionId: positionId)
    }
}

@objc protocol AddElementToListListener: AnyObject {
    func addElementToList(element: Any)
    func removeElementFromList(element: Any)
}
