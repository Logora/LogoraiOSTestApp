//
//  Routable.swift
//  LogoraSDK
//
//  Created by Logora mac on 20/05/2021.
//

import Foundation

protocol Routable: AnyObject {
    func getRouteName() -> String
    
    func getRouteParam() -> String
}
