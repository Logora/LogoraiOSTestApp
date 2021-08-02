//
//  Level.swift
//  LogoraSDK
//
//  Created by Logora mac on 11/05/2021.
//

import Foundation

struct Level: Codable {
    let id: Int?
    var name: String?
    var iconURL: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case iconURL = "icon_url"
    }
}
