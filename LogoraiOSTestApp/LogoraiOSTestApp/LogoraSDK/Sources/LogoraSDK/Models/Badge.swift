import Foundation

class Badge: Codable, Routable {
    let updatedAt: String?
    let id: Int
    let name: String
    let level: Int
    let description, title: String
    let iconURL: String
    let hidden: Bool
    let steps: Int?
    let createdAt: String?

    enum CodingKeys: String, CodingKey {
        case updatedAt = "updated_at"
        case id, name, level
        case description
        case title
        case iconURL = "icon_url"
        case hidden, steps
        case createdAt = "created_at"
    }
    
    func getRouteName() -> String {
        return ""
    }
    
    func getRouteParam() -> String {
        return ""
    }
}
