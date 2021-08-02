import Foundation

struct Token: Codable {
    let accessToken, tokenType: String
    let expiresIn: Int
    let refreshToken, scope: String
    let createdAt: Int
    let success: String?

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case refreshToken = "refresh_token"
        case scope
        case success
        case createdAt = "created_at"
    }
}
