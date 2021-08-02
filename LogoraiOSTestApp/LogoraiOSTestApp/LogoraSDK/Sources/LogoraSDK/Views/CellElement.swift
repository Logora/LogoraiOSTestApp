//
//  CellElement.swift
//  LogoraSDK
//
//  Created by Logora mac on 18/05/2021.
//
import Foundation
import UIKit

protocol CellElement: AnyObject {
    func setResource(resource: Codable)
    
    func configure()
    
    func getHeight() -> CGFloat
}
