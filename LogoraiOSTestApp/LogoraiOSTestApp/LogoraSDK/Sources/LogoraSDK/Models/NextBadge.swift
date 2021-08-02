import Foundation

class NextBadge: Codable, Routable {
    let badge: Badge
    let progress: Int
    
    func getRouteName() -> String {
        return ""
    }
    
    func getRouteParam() -> String {
        return ""
    }
}
