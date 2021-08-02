import Foundation

struct Vote: Codable {
    let id: Int
    let positionId: Int?
    let isUpvote: Bool?
    let userId: Int?
    let voteableType: String?
    let voteableId: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case positionId = "position_id"
        case isUpvote = "is_upvote"
        case voteableId = "voteable_id"
        case voteableType = "voteable_type"
        case userId = "user_id"
    }
}
