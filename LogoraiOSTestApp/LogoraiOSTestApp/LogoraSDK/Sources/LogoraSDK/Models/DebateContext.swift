//
//  GroupContext.swift
//  LogoraSDK
//
//  Created by Logora mac on 11/05/2021.
//

import Foundation

struct DebateContext: Codable {
    let id: Int
    let name, createdAt: String
    let tagList: [JSONAny]?
    let positions: [Position]
    let tags: [Tag]?

    enum CodingKeys: String, CodingKey {
        case id, name
        case createdAt = "created_at"
        case tagList = "tag_list"
        case positions, tags
    }
}
