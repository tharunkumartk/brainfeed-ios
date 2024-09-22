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
}
