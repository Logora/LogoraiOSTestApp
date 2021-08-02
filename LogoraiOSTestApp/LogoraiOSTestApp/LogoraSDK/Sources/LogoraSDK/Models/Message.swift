//
//  Message.swift
//  LogoraSDK
//
//  Created by Logora mac on 11/05/2021.
//

import Foundation

class Message: Codable, Routable {
    let id: Int
    let isPro: Bool
    let content: String
    let richContent: String?
    let upvotes, groupID: Int
    let isReply: Bool
    let createdAt: String
    let updatedAt: String?
    let score: Double
    let status: String
    let replyToID: Int?
    let numberReplies: Int?
    let repliesAuthors: [RepliesAuthor]?
    let author: User
    let directURL: String?
    let position: Position
    let votes: [Vote]?
    var group: Debate?
    let sources: [JSONAny]?

    enum CodingKeys: String, CodingKey {
        case id
        case isPro = "is_pro"
        case content
        case richContent = "rich_content"
        case upvotes
        case groupID = "group_id"
        case isReply = "is_reply"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case score, status
        case replyToID = "reply_to_id"
        case numberReplies = "number_replies"
        case repliesAuthors = "replies_authors"
        case directURL = "direct_url"
        case author, position, group, votes, sources
    }
    
    func getRouteName() -> String {
        return "DEBATE"
    }
    
    func getRouteParam() -> String {
        return ""
    }
    
    func getHasUserVoted(userId: Int) -> Bool {
        for (i, _) in self.votes!.enumerated() {
            if(self.votes![i].userId == userId){
                return true;
            }
        }
        return false;
    }

    func getUserVoteId(userId: Int) -> Int {
        for (i, _) in self.votes!.enumerated() {
            if(self.votes![i].userId == userId){
                return self.votes![i].id;
            }
        }
        return 0;
    }

}

struct RepliesAuthor: Codable {
    let fullName: String?
    let imageURL: String?
    
    enum CodingKeys: String, CodingKey {
        case fullName = "full_name"
        case imageURL = "image_url"
    }
}
