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

struct RandomPostsWrapper: Codable {
    let posts: [Post]
}

struct LikeUnlikeResponse: Codable {
    let message: String
}

class UserService {
    static func markPostAsViewed(userId: String, postId: String) async throws {
        print("Marking post with ID: \(postId) as viewed for user: \(userId)")
        guard let url = APIURLConstructor.makeURL(path: "/users/\(userId)/view-post") else {
            print("Error: Invalid URL for marking post as viewed")
            throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
        }
                
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
        let requestBody = ["postId": postId]
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)
                
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
                    
            print("Received data for marking post as viewed. Size: \(data.count) bytes")
                    
            // Print the entire JSON response
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw JSON response for marking post as viewed:")
                print(jsonString)
            } else {
                print("Unable to convert data to string for marking post as viewed")
            }
                    
            // You can decode the response if needed, similar to other functions
            // For now, we'll just print a success message
            print("Successfully marked post as viewed")
        } catch {
            print("Error marking post as viewed: \(error.localizedDescription)")
            throw error
        }
    }
    
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
    
    static func fetchRandomPosts(count: Int) async throws -> [Post] {
        print("Fetching \(count) random posts")
        guard var urlComponents = URLComponents(url: APIURLConstructor.makeURL(path: "/posts/random")!, resolvingAgainstBaseURL: true) else {
            print("Error: Invalid URL for random posts fetch")
            throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
        }
            
        urlComponents.queryItems = [URLQueryItem(name: "count", value: String(count))]
            
        guard let url = urlComponents.url else {
            print("Error: Failed to construct URL with query parameters")
            throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
        }
            
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
                
            print("Received data for random posts fetch. Size: \(data.count) bytes")
                
            // Print the entire JSON response
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw JSON response for random posts fetch:")
                print(jsonString)
            } else {
                print("Unable to convert data to string for random posts fetch")
            }
                
            let wrapper = try JSONDecoder().decode(RandomPostsWrapper.self, from: data)
            print("Successfully decoded \(wrapper.posts.count) random posts")
            return wrapper.posts
        } catch {
            print("Error fetching random posts: \(error.localizedDescription)")
            throw error
        }
    }
    
    static func likePost(postId: String, userId: String) async throws {
        print("Liking post with ID: \(postId) for user: \(userId)")
        guard let url = APIURLConstructor.makeURL(path: "/posts/\(postId)/like") else {
            print("Error: Invalid URL for liking post")
            throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
        }
            
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
        // Create the request body with userId
        let requestBody = ["userId": userId]
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)
            
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
                
            print("Received data for liking post. Size: \(data.count) bytes")
                
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw JSON response for liking post:")
                print(jsonString)
            } else {
                print("Unable to convert data to string for liking post")
            }
                
            let response = try JSONDecoder().decode(LikeUnlikeResponse.self, from: data)
            print("Successfully liked post. Server message: \(response.message)")
        } catch {
            print("Error liking post: \(error.localizedDescription)")
            throw error
        }
    }

    static func unlikePost(postId: String, userId: String) async throws {
        print("Unliking post with ID: \(postId) for user: \(userId)")
        guard let url = APIURLConstructor.makeURL(path: "/posts/\(postId)/unlike") else {
            print("Error: Invalid URL for unliking post")
            throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
        }
            
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
        // Create the request body with userId
        let requestBody = ["userId": userId]
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)
            
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
                
            print("Received data for unliking post. Size: \(data.count) bytes")
                
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw JSON response for unliking post:")
                print(jsonString)
            } else {
                print("Unable to convert data to string for unliking post")
            }
                
            let response = try JSONDecoder().decode(LikeUnlikeResponse.self, from: data)
            print("Successfully unliked post. Server message: \(response.message)")
        } catch {
            print("Error unliking post: \(error.localizedDescription)")
            throw error
        }
    }
}
