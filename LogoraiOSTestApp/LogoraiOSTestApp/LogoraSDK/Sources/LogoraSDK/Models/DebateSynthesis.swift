import Foundation

struct DebateSynthesis: Codable {
    let id: Int
    let name, slug, directURL: String

    enum CodingKeys: String, CodingKey {
        case id, name, slug
        case directURL = "direct_url"
    }
}

