import SwiftUI

struct FeedView: View {
    @StateObject private var viewModel = FeedViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 10) {
                    if let currentUser = viewModel.currentUser {
                        ForEach(viewModel.posts) { post in
                            PostView(post: post, isLiked: currentUser.likes.contains(post.id))
                                .onAppear {
                                    if post == viewModel.posts.last {
                                        Task {
                                            await viewModel.loadMorePosts()
                                        }
                                    }
                                }
                        }
                    }
                    if viewModel.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                    }
                }
            }
            .refreshable {
                await viewModel.loadMorePosts()
            }
            .navigationTitle("BrainFeed")
        }
        .environmentObject(viewModel)
    }
}

#Preview {
    FeedView()
}
