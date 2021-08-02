//
//  Position.swift
//  LogoraSDK
//
//  Created by Logora mac on 11/05/2021.
//

import Foundation

struct Position: Codable {
    let updatedAt: String?
    let id: Int
    let name: String?

    enum CodingKeys: String, CodingKey {
        case updatedAt = "updated_at"
        case id, name
    }
}
