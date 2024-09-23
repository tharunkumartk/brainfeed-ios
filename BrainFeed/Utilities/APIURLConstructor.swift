//
//  APIURLConstructor.swift
//  BrainFeed
//
//  Created by Tharun Kumar on 9/21/24.
//

import Foundation

class APIURLConstructor {
//    static let baseURL = "https://brainfeed-api-server-1017028393149.us-central1.run.app" // Replace with your actual base URL
    static let baseURL = "http://localhost:3000"

    static func makeURL(path: String) -> URL? {
        let fullURL = "\(baseURL)\(path)"
        print("Constructed URL: \(fullURL)")
        return URL(string: fullURL)
    }
}
