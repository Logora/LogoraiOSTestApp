//
//  UIViewControllerExtension.swift
//  LogoraSDK
//
//  Created by Logora mac on 26/05/2021.
//

import UIKit

extension UIViewController {
    public var safeAreaTop: CGFloat {
        if #available(iOS 11.0, *) {
            return self.view.safeAreaInsets.top
        } else {
            return self.topLayoutGuide.length
        }
    }
    
    public var safeAreaBottom: CGFloat {
        if #available(iOS 11.0, *) {
            return self.view.safeAreaInsets.bottom
        } else {
            return self.bottomLayoutGuide.length
        }
    }
}
