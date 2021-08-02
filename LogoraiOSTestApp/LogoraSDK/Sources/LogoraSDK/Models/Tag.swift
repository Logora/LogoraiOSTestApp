//
//  Tag.swift
//  LogoraSDK
//
//  Created by Logora mac on 11/05/2021.
//

import Foundation

struct Tag: Codable {
    let id: Int?
    let name: String?
    let taggingsCount: Int?
    let displayName: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case taggingsCount = "taggings_count"
        case displayName = "display_name"
    }
}
