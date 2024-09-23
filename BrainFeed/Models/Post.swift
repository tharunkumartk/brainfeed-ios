//
//  Post.swift
//  BrainFeed
//
//  Created by Tharun Kumar on 9/21/24.
//

import Foundation

struct Post: Identifiable, Hashable, Codable {
    let id: String
    let content: String
    let link: String
    let title: String
    var likeCount: Int
    let date: Date
    
    enum CodingKeys: String, CodingKey {
        case id, content, link, title, likeCount, date
    }
    
    init(id: String, content: String, link: String, title: String, likeCount: Int, date: Date) {
        self.id = id
        self.content = content
        self.link = link
        self.title = title
        self.likeCount = likeCount
        self.date = date
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        content = try container.decode(String.self, forKey: .content)
        link = try container.decode(String.self, forKey: .link)
        title = try container.decode(String.self, forKey: .title)
        likeCount = try container.decode(Int.self, forKey: .likeCount)
        
        // Decode date from ISO8601 string
        let dateString = try container.decode(String.self, forKey: .date)
        if let date = ISO8601DateFormatter().date(from: dateString) {
            self.date = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .date, in: container, debugDescription: "Date string does not match expected format")
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(content, forKey: .content)
        try container.encode(link, forKey: .link)
        try container.encode(title, forKey: .title)
        try container.encode(likeCount, forKey: .likeCount)
        
        // Encode date to ISO8601 string
        let dateString = ISO8601DateFormatter().string(from: date)
        try container.encode(dateString, forKey: .date)
    }
}
