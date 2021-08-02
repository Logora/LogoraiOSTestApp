import Foundation

struct Following: Codable {
    let follow: Bool
    let resource: FollowingResource?
    
    enum CodingKeys: String, CodingKey {
        case follow
        case resource
    }
}

struct FollowingResource: Codable {
    let id, groupId, userId: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case groupId = "group_id"
        case userId = "user_id"
    }
}
