//
//  PostView.swift
//  BrainFeed
//
//  Created by Tharun Kumar on 9/21/24.
//

import SwiftUI

struct PostView: View {
    @Environment(\.openURL) private var openURL
    @EnvironmentObject var viewModel: FeedViewModel
    let post: Post
    let isLiked: Bool
    @State var isLoadingLike = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(post.title)
                .font(.headline)
                .fontWeight(.bold)
            
            Text(post.content)
                .font(.body)
                .padding(.bottom, 20)
            
            HStack(alignment: .top, spacing: 15) {
                Text(formatDate(post.date))
                    .font(.caption)
                Spacer()
                VStack {
                    Button(action: {
                        Task {
                            isLoadingLike = true
                            do {
                                if isLiked {
                                    try await UserService.unlikePost(postId: post.id, userId: getUserId())
                                } else {
                                    try await UserService.likePost(postId: post.id, userId: getUserId())
                                }
                                await viewModel.fetchOrCreateUser()
                            } catch {
                                print("Error liking post: \(error)")
                            }
                            isLoadingLike = false
                        }
                    }) {
                        if isLoadingLike {
                            ProgressView()
                                .frame(width: 25)
                        } else {
                            Image(systemName: isLiked ? "heart.fill" : "heart")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25)
                        }
                    }
                    .foregroundStyle(.accent)
                    if post.likeCount > 0 {
                        Text("\(post.likeCount)")
                            .font(.caption)
                    }
                }
                Button(action: {
                    openPostLink()
                }) {
                    Image(systemName: "link")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25)
                }
                .foregroundStyle(.blue)
                
                ShareLink(item: URL(string: post.link) ?? URL(string: "https://example.com")!) {
                    Image(systemName: "square.and.arrow.up")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20)
                }
            }
            .foregroundColor(.gray)
            
            Divider()
        }
        .onDisappear(perform: {
            print("Post \(post.id) has disappeared!")
        })
        .padding()
    }
    
    private func getUserId() -> String {
        let uuid = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
        return uuid
    }
    
    private func openPostLink() {
        guard let url = URL(string: post.link) else {
            print("Invalid URL: \(post.link)")
            return
        }
        openURL(url) { success in
            if !success {
                print("Failed to open URL: \(url)")
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let now = Date()
        print("Pre-formatted date: \(date.description) Current date: \(now.description)")
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date, to: now)
        
        if let years = components.year, years > 0 {
            return "\(years) year\(years == 1 ? "" : "s") ago"
        } else if let months = components.month, months > 0 {
            return "\(months) month\(months == 1 ? "" : "s") ago"
        } else if let days = components.day, days > 0 {
            if days >= 7 {
                let weeks = days / 7
                return "\(weeks) week\(weeks == 1 ? "" : "s") ago"
            }
            return "\(days) day\(days == 1 ? "" : "s") ago"
        } else if let hours = components.hour, hours > 0 {
            return "\(hours) hour\(hours == 1 ? "" : "s") ago"
        } else if let minutes = components.minute, minutes > 0 {
            return "\(minutes) minute\(minutes == 1 ? "" : "s") ago"
        } else {
            return "Just now"
        }
    }
}

#Preview {
    PostView(post: Post(
        id: "1",
        content: "This is a sample post content. It demonstrates how the PostView looks with some example text.",
        link: "https://example.com",
        title: "Sample Post Title",
        likeCount: 10,
        date: Date().addingTimeInterval(-3600 * 3) // 3 hours ago
    ), isLiked: true)
        .environmentObject(FeedViewModel())
}
