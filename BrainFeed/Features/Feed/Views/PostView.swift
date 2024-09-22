//
//  PostView.swift
//  BrainFeed
//
//  Created by Tharun Kumar on 9/21/24.
//

import SwiftUI

struct PostView: View {
    let post: Post

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(post.title)
                .font(.headline)
                .fontWeight(.bold)

            Text(post.content)
                .font(.body)
                .padding(.bottom, 20)

            HStack(spacing: 15) {
                Spacer()

                Button(action: {
                    // Handle like action
                }) {
                    Image(systemName: "heart")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25)
                }

                Button(action: {
                    // Handle share action
                }) {
                    Image(systemName: "link")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25)
                }

                Button(action: {
                    // Handle save action
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20)
                }
            }
            .foregroundColor(.gray)
//            Divider()
        }
//        .padding()
    }
}

#Preview {
    PostView(post: Post(
        id: "1",
        content: "This is a sample post content. It demonstrates how the PostView looks with some example text.",
        link: "https://example.com",
        title: "Sample Post Title",
        likeCount: 42
    ))
}
