//
//  Router.swift
//  LogoraSDK
//
//  Created by Logora mac on 17/05/2021.
//

import Foundation

class Router {
    static let sharedInstance = Router()
    private var currentRouteName: String?
    
    weak var listener : RouteChangeListener? = nil
    
    func setRoute(routeName: String, routeParam: String) {
        self.currentRouteName = routeName
        listener?.routeChanged(routeName: routeName, routeParam: routeParam)
    }
}

@objc protocol RouteChangeListener: AnyObject {
    func routeChanged(routeName: String, routeParam: String)
}
