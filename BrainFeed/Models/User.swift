//
//  User.swift
//  BrainFeed
//
//  Created by Tharun Kumar on 9/21/24.
//

import Foundation

struct User: Identifiable, Codable, Hashable {
    let id: String
    var likes: [String]
    var viewedPosts: [String]
}
