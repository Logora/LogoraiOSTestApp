//
//  TextWrapper.swift
//  LogoraSDK
//
//  Created by Logora mac on 26/05/2021.
//
import Foundation
import UIKit

class TextWrapper: UILabel {
    let settings: SettingsProvider = SettingsProvider.sharedInstance
    private var textKey: String!
    
    required init(textKey: String) {
        super.init(frame: .zero)
        self.textKey = textKey
        
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    func setup() {
        self.text = UtilsProvider.getLocalizedString(textKey: self.textKey)
    }
}
