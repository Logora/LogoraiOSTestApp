//
//  UIFontExtension.swift
//  LogoraSDK
//
//  Created by Logora mac on 04/06/2021.
//

import Foundation

extension UIFont {

    func withTraits(_ traits:UIFontDescriptorSymbolicTraits...) -> UIFont {
        let descriptor = self.fontDescriptor
            .withSymbolicTraits(UIFontDescriptorSymbolicTraits(traits).union(self.fontDescriptor.symbolicTraits))
        return UIFont(descriptor: descriptor!, size: 0)
    }
    func withoutTraits(_ traits:UIFontDescriptorSymbolicTraits...) -> UIFont {
        let descriptor = self.fontDescriptor
            .withSymbolicTraits(  self.fontDescriptor.symbolicTraits.subtracting(UIFontDescriptorSymbolicTraits(traits)))
        return UIFont(descriptor: descriptor!, size: 0)
    }
    func bold() -> UIFont {
        return withTraits( .traitBold)
    }

    func italic() -> UIFont {
        return withTraits(.traitItalic)
    }

    func noItalic() -> UIFont {
        return withoutTraits(.traitItalic)
    }
    func noBold() -> UIFont {
        return withoutTraits(.traitBold)
    }
}
