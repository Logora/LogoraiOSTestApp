import UIKit

class Debate: Codable, Routable {
    let id: Int
    let name, slug: String?
    let createdAt: String
    let updatedAt: String?
    let endsAt: String?
    let score: Double
    let isPublic, isActive: Bool?
    let messagesCount: Int?
    let imageURL: String
    let directURL: String
    let reducedSynthesis, isPublished: Bool?
    let participantsCount: Int
    var votesCount: [String: String]
    let groupContext: DebateContext
    let participants: [User]?
    var totalVotesCount = 0
    var winningVotePercentage = 50
    var votesPercentages: [String: Double] = [:]

    enum CodingKeys: String, CodingKey {
        case id, name, slug
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case endsAt = "ends_at"
        case score
        case isPublic = "is_public"
        case isActive = "is_active"
        case messagesCount = "messages_count"
        case imageURL = "image_url"
        case directURL = "direct_url"
        case reducedSynthesis = "reduced_synthesis"
        case isPublished = "is_published"
        case participantsCount = "participants_count"
        case votesCount = "votes_count"
        case groupContext = "group_context"
        case participants
    }
    
    func getRouteName() -> String {
        return "DEBATE"
    }
    
    func getRouteParam() -> String {
        return self.slug!
    }
    
    func getTotalVotesCount() -> Int {
        return self.totalVotesCount;
    }

    func setTotalVotesCount(totalVotesCount: Int) {
        self.totalVotesCount = totalVotesCount;
    }
    
    func getWinningVotePercentage() -> Int {
        return self.winningVotePercentage;
    }

    func setWinningVotePercentage(winningVotePercentage: Int) {
        self.winningVotePercentage = winningVotePercentage;
    }

    func getVotePercentages() -> [String: Double] {
        return self.votesPercentages
    }
    
    func getPositionIndex(index: Int) -> Int {
        let positionList = self.groupContext.positions
        var positionIndex: Int? = 0
        for (i, _) in positionList.enumerated() {
            if (positionList[i].id == index) {
                positionIndex = i
                return positionIndex!
            }
        }
        return 0
    }
    
    func initVotePercentage() {
        let maxValue: Int = 50;
        self.setTotalVotesCount(totalVotesCount: Int(votesCount["total"] ?? "0")!)
        for (key, value) in votesCount {
            if (key == "total") {
                continue
            } else {
                let positionId: String = key
                var percentage: Double!
                if (totalVotesCount != 0) {
                    percentage = Double(((100 * (value as NSString).integerValue) / totalVotesCount))
                } else {
                    percentage = Double(maxValue)
                }
                if (Int(percentage) > maxValue) {
                    self.setWinningVotePercentage(winningVotePercentage: Int(percentage));
                }
                self.votesPercentages[positionId] = percentage
            }
        }
    }
    
    func calculateVotePercentage(positionId: String, isUpdate: Bool) {
        for (key, _) in votesCount {
            if (key == positionId) {
                votesCount.updateValue(String((votesCount[key]! as NSString).integerValue + 1), forKey: key)
            } else {
                if (isUpdate) {
                    votesCount.updateValue(String((votesCount[key]! as NSString).integerValue - 1), forKey: key)
                }
            }
        }
        self.initVotePercentage();
    }
}
