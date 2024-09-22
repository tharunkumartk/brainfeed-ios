import Combine
import Foundation
import UIKit

class FeedViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var isLoading = false
    @Published var error: Error?
    @Published var posts: [Post] = []
    
    private var currentPage = 0
    private let postsPerPage = 10
    private var canLoadMorePosts = true
    
    init() {
        Task {
            await fetchOrCreateUser()
            await loadMorePosts()
        }
    }
    
    @MainActor
    func fetchOrCreateUser() async {
        isLoading = true
        error = nil
        
        do {
            let userId = getUserId()
            let user = try await UserService.fetchUser(userId: userId)
            currentUser = user
        } catch {
            // Handle the case where the user doesn't exist
            do {
                let userId = getUserId()
                let newUser = try await UserService.createUser(id: userId)
                currentUser = newUser
            } catch {
                self.error = error
            }
        }
        
        isLoading = false
    }
    
    private func getUserId() -> String {
        let uuid = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
        return uuid
    }
    
    @MainActor
    func loadMorePosts() async {
        guard !isLoading && canLoadMorePosts else { return }
        
        isLoading = true
        error = nil
        
        do {
            let newPosts = try await fetchPosts(page: currentPage, limit: postsPerPage)
            posts.append(contentsOf: newPosts)
            currentPage += 1
            canLoadMorePosts = newPosts.count == postsPerPage
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
    
    private func fetchPosts(page: Int, limit: Int) async throws -> [Post] {
        // This is a placeholder function. Replace with actual API call in production.
        // Simulating network delay
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        // Generate placeholder posts
        return (0 ..< limit).map { index in
            let postIndex = page * limit + index
            return Post(
                id: UUID().uuidString,
                content: "This is post content for post #\(postIndex + 1)",
                link: "https://example.com/post/\(postIndex + 1)",
                title: "Post #\(postIndex + 1)",
                likeCount: Int.random(in: 0 ... 100)
            )
        }
    }
}
