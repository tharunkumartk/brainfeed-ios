//
//  UserService.swift
//  BrainFeed
//
//  Created by Tharun Kumar on 9/21/24.
//

import Foundation

struct UserCreationResponse: Codable {
    let user: User
    let message: String
}

struct UserResponse: Codable {
    let user: User
}

class UserService {
    static func createUser(id: String) async throws -> User {
        print("Creating user with ID: \(id)")
        guard let url = APIURLConstructor.makeURL(path: "/users") else {
            print("Error: Invalid URL for user creation")
            throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
        }
            
        let userData = ["id": id]
        let jsonData = try JSONSerialization.data(withJSONObject: userData)
            
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
            
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
                
            print("Received data for user creation. Size: \(data.count) bytes")
                
            // Print the entire JSON response
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw JSON response for user creation:")
                print(jsonString)
            } else {
                print("Unable to convert data to string for user creation")
            }
                
            let response = try JSONDecoder().decode(UserCreationResponse.self, from: data)
            print("Successfully created user: \(response.user)")
            print("Server message: \(response.message)")
            return response.user
        } catch {
            print("Error creating user: \(error.localizedDescription)")
            throw error
        }
    }

    static func fetchUser(userId: String) async throws -> User {
        print("Fetching user with ID: \(userId)")
        guard let url = APIURLConstructor.makeURL(path: "/users/\(userId)") else {
            print("Error: Invalid URL for user fetch")
            throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
        }
            
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
                
            print("Received data for user fetch. Size: \(data.count) bytes")
                
            // Print the entire JSON response
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw JSON response for user fetch:")
                print(jsonString)
            } else {
                print("Unable to convert data to string for user fetch")
            }
                
            let response = try JSONDecoder().decode(UserResponse.self, from: data)
            let user = response.user
            print("Successfully decoded user: \(user)")
            return user
        } catch {
            print("Error fetching user: \(error.localizedDescription)")
            throw error
        }
    }
    
    static func fetchNewPosts(for userId: String) async throws -> [Post] {
        print("Fetching new posts for user with ID: \(userId)")
        guard let url = APIURLConstructor.makeURL(path: "/users/\(userId)/new-posts") else {
            print("Error: Invalid URL for new posts fetch")
            throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            print("Received data for new posts fetch. Size: \(data.count) bytes")
            
            // Print the entire JSON response
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw JSON response for new posts fetch:")
                print(jsonString)
            } else {
                print("Unable to convert data to string for new posts fetch")
            }
            
            let posts = try JSONDecoder().decode([Post].self, from: data)
            print("Successfully decoded \(posts.count) new posts")
            return posts
        } catch {
            print("Error fetching new posts: \(error.localizedDescription)")
            throw error
        }
    }
}
