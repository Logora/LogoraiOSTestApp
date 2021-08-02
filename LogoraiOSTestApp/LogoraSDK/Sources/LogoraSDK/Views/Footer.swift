//
//  Footer.swift
//  LogoraSDK
//
//  Created by Logora mac on 11/05/2021.
//

import UIKit

class Footer: UIView {
    @IBOutlet var contentView : UIView!
    @IBOutlet weak var moderationTermsLabel: UILabel!
    @IBOutlet weak var improvementsLabel: UILabel!
    @IBOutlet weak var gcuLabel: UILabel!
    @IBOutlet weak var identityLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetUp()
    }
    
    func xibSetUp() {
        contentView = loadViewFromNib()
        contentView.frame = self.bounds
        contentView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        contentView.addBorder(hexString: SettingsProvider.sharedInstance.getTheme(key: "borderBoxColor"), width: 0.2)
        contentView.addShadow(offset: CGSize.init(width: 0, height: 1), color: UIColor.init(hexString: SettingsProvider.sharedInstance.getTheme(key: "borderBoxColor")), radius: 5, opacity: 0.35)
        initActions()
        addSubview(contentView)
        contentView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self).inset(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        }
    }

    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
    
    func initActions(){
        let moderationTermsLabelTap = UITapGestureRecognizer(target: self, action: #selector(goToModerationTerms))
        let improvementsLabelTap = UITapGestureRecognizer(target: self, action: #selector(goToImprovements))
        let gcuLabelTap = UITapGestureRecognizer(target: self, action: #selector(goToGCU))
        let identityLabelTap = UITapGestureRecognizer(target: self, action: #selector(goToLogora))
        moderationTermsLabel.addGestureRecognizer(moderationTermsLabelTap)
        improvementsLabel.addGestureRecognizer(improvementsLabelTap)
        gcuLabel.addGestureRecognizer(gcuLabelTap)
        identityLabel.addGestureRecognizer(identityLabelTap)
    }
    
    @objc func goToModerationTerms(sender:UITapGestureRecognizer) {
        let url = URL(string: "https://logora.fr/moderation")!
        UIApplication.shared.open(url)
    }
    
    @objc func goToImprovements(sender:UITapGestureRecognizer) {
        let url = URL(string: "https://6ao8u160j88.typeform.com/to/mjcnSNqD")!
        UIApplication.shared.open(url)
    }
    
    @objc func goToGCU(sender:UITapGestureRecognizer) {
        let url = URL(string: "https://logora.fr/cgu")!
        UIApplication.shared.open(url)
    }
    
    @objc func goToLogora(sender:UITapGestureRecognizer) {
        let url = URL(string: "https://logora.fr/")!
        UIApplication.shared.open(url)
    }
}
