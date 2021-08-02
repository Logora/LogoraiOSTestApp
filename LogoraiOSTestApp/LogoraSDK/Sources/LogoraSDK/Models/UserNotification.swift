import Foundation

class UserNotification: Decodable, Routable {
    let id: Int
    let actor: User
    let notifyType, redirectUrl: String
    let isOpened: Bool
    let createdAt: String
    let actorCount: Int?
    let target: Codable?
    let secondTarget: Codable?
    let thirdTarget: Codable?

    enum CodingKeys: String, CodingKey {
        case id, actor
        case notifyType = "notify_type"
        case redirectUrl = "redirect_url"
        case isOpened = "is_opened"
        case createdAt = "created_at"
        case actorCount = "actor_count"
        case target
        case secondTarget = "second_target"
        case thirdTarget = "third_target"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.actor = try container.decode(User.self, forKey: .actor)
        self.actorCount = try container.decode(Int.self, forKey: .actorCount)
        self.isOpened = try container.decode(Bool.self, forKey: .isOpened)
        self.createdAt = try container.decode(String.self, forKey: .createdAt)
        self.redirectUrl = try container.decode(String.self, forKey: .redirectUrl)
        self.notifyType = try container.decode(String.self, forKey: .notifyType)
        switch try container.decode(String.self, forKey: .notifyType) {
            case "get_badge":
                self.target = nil
                self.secondTarget = try container.decode(Badge.self, forKey: .secondTarget)
                self.thirdTarget = nil
            case "group_reply":
                self.target = try container.decode(Message.self, forKey: .target);
                self.secondTarget = try container.decode(Debate.self, forKey: .secondTarget);
                self.thirdTarget = try container.decode(Message.self, forKey: .thirdTarget)
            case "level_unlock":
                self.target = try container.decode(User.self, forKey: .target)
                self.secondTarget = nil
                self.thirdTarget = nil
            case "user_follow_level_unlock":
                self.target = nil
                self.secondTarget = nil
                self.thirdTarget = nil
            case "get_vote":
                self.target = nil
                self.secondTarget = nil
                self.thirdTarget = nil
            case "group_follow_argument":
                self.target = nil
                self.secondTarget = nil
                self.thirdTarget = nil
            case "followed":
                self.target = nil
                self.secondTarget = nil
                self.thirdTarget = nil
            case "group_invitation_new":
                self.target = nil
                self.secondTarget = nil
                self.thirdTarget = nil
            default:
                throw DecodingError.dataCorruptedError(forKey: .notifyType, in: container, debugDescription: "Unknown notifyType")
        }
    }
    
    func getRouteName() -> String {
        return ""
    }
    
    func getRouteParam() -> String {
        return ""
    }
}

extension UserNotification: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(actor, forKey: .actor)
        try container.encode(notifyType, forKey: .notifyType)
        try container.encode(redirectUrl, forKey: .redirectUrl)
        try container.encode(isOpened, forKey: .isOpened)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(actorCount, forKey: .actorCount)
    }
}
