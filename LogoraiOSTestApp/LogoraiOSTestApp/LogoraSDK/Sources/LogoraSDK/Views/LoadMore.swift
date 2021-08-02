import UIKit

class LoadMore: UITableViewCell {
    var buttonTapCallback: () -> ()  = { }
        
    let button: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor.init(hexString: SettingsProvider.sharedInstance.getTheme(key: "callPrimaryColor"))
        btn.layer.cornerRadius = 6
        btn.tintColor = .white
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        btn.setTitle(UtilsProvider.getLocalizedString(textKey: "view_more"), for: .normal)
        return btn
    }()
    
    @objc func didTapButton() {
        buttonTapCallback()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //Add button
        contentView.addSubview(button)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
        //Set constraints as per your requirements
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
