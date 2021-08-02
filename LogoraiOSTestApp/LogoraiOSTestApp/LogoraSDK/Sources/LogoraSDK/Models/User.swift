import Foundation

class User: Codable, Routable {
    let id: Int?
    let imageURL: String?
    let fullName, firstName, lastName: String?
    let level, nextLevel: Level?
    let nextLevelProgress, score: Double?
    let slug: String?
    let points: Int?
    let receivesEmails: Bool?
    let uid: String?
    let isBanned: Bool?
    let debatesCount, followersCount, debatesVotesCount, notificationsCount: Int?
    let disciples: [Disciple]?
    let tags: [TagElement]?
    let lastActivity: String?
    let receivesActivityEmail, receivesReportEmail, receivesUserFollowedEmail, receivesNewsletterEmail, receivesGroupFollowedEmail: Bool?

    enum CodingKeys: String, CodingKey {
        case id
        case imageURL = "image_url"
        case fullName = "full_name"
        case firstName = "first_name"
        case lastName = "last_name"
        case level
        case nextLevel = "next_level"
        case nextLevelProgress = "next_level_progress"
        case score, slug, points
        case notificationsCount = "notifications_count"
        case receivesEmails = "receives_emails"
        case uid
        case isBanned = "is_banned"
        case debatesCount = "debates_count"
        case followersCount = "followers_count"
        case debatesVotesCount = "debates_votes_count"
        case disciples, tags
        case lastActivity = "last_activity"
        case receivesActivityEmail = "receives_activity_email"
        case receivesReportEmail = "receives_report_email"
        case receivesUserFollowedEmail = "receives_user_followed_email"
        case receivesNewsletterEmail = "receives_newsletter_email"
        case receivesGroupFollowedEmail = "receives_group_followed_email"
    }
    
    func getRouteName() -> String {
        return "USER"
    }
    
    func getRouteParam() -> String {
        return self.slug!
    }
}

struct Disciple: Codable {
    let updatedAt: String?
    let id: Int?

    enum CodingKeys: String, CodingKey {
        case updatedAt = "updated_at"
        case id
    }
}

struct TagElement: Codable {
    let id, totalPoints, participationCount: Int?
    let tag: Tag?

    enum CodingKeys: String, CodingKey {
        case id
        case totalPoints = "total_points"
        case participationCount = "participation_count"
        case tag
    }
}
