import SwiftUI

struct FeedView: View {
    @StateObject private var viewModel = FeedViewModel()

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.posts) { post in
                    PostView(post: post)
                        .onAppear {
                            if post == viewModel.posts.last {
                                Task {
                                    await viewModel.loadMorePosts()
                                }
                            }
                        }
                }

                if viewModel.isLoading {
                    ProgressView()
                        .frame(idealWidth: .infinity, alignment: .center)
                }
            }
            .listStyle(PlainListStyle())
            .navigationTitle("BrainFeed")
            .refreshable {
                await viewModel.loadMorePosts()
            }
        }
        .environmentObject(viewModel)
    }
}

#Preview {
    FeedView()
}
