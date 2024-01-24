//
//  CarouselViewSecond.swift
//  CarouselExample
//
//  Created by Иван Чернокнижников on 24.01.2024.
//

import SwiftUI

struct CarouselViewSecond: View {
    
    @State var posts : [Post] = []

    var body: some View {
        ScrollView(.horizontal,showsIndicators: false) {
            LazyHStack(spacing: 0) {
                ForEach(posts.indices, id: \.self) { index in
                    Image(posts[index].postImage)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 450)
                        .clipShape(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/))
                        .padding(.horizontal,20)
                        .scrollTransition(.animated,axis: .horizontal) { content, phase in
                            content.opacity(phase.isIdentity ? 1 : 0.8)
                                .scaleEffect(phase.isIdentity ? 1 : 0.8)
                            
                        }
                        .containerRelativeFrame(.horizontal)
                }
            }
        }
        .scrollTargetBehavior(.paging)
        .onAppear {
            for index in 1...5 {
                posts.append(Post(postImage: "poster\(index)"))
            }
        }
    }
}

#Preview {
    CarouselViewSecond()
}
