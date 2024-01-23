//
//  HomeView.swift
//  CarouselExample
//
//  Created by Иван Чернокнижников on 22.01.2024.
//

import SwiftUI

struct HomeView: View {
     
    @State var currentIndex : Int = 0
    
    @State var posts : [Post] = []
    
    @State var currentTab = "Slide Show"
    
    @Namespace var animation
        
    var body: some View {
        VStack(spacing:15) {
            VStack(alignment: .leading, spacing:12) {
                
                Button {
                    
                }label: {
                    Label {
                        Text("Back")
                            .fontWeight(.semibold)
                    } icon: {
                        Image(systemName: "chevron.left")
                    }
                    .foregroundStyle(.black)
                }
                Text("My Wishes")
                    .font(.title)
                    .fontWeight(.bold)
                
            }
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,alignment: .leading)
            .padding()
            
            // Segment Control
            
            HStack(spacing: 0) {
                TabButton(title: "Slide Show", animation: animation, currentTab: $currentTab)
                TabButton(title: "List", animation: animation, currentTab: $currentTab)
            }
            .background(Color.black.opacity(0.04),in: RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal)

            // Snap Carousel
            SnapCarousel(index: $currentIndex, items: posts) { post in
                GeometryReader { proxy in
                    let size = proxy.size
                    Image(post.postImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width)
                        .cornerRadius(10)
                    
                }
                
            }
            .padding(.vertical,40)
            
            // Indicator
            HStack(spacing: 10) {
                ForEach(posts.indices,id: \.self) { index in
                    Circle()
                        .fill(Color.black.opacity(currentIndex == index ? 1 : 0.1))
                        .frame(width: 10,height: 10)
                        .scaleEffect(currentIndex == index ? 1.4: 1)
                        .animation(.spring(), value: currentIndex == index)
                }
            }
            .padding(.bottom,40)
        }
        .frame(maxHeight: .infinity,alignment: .top)
        .onAppear {
            for index in 1...5 {
                posts.append(Post(postImage: "poster\(index)"))
            }
        }
    }
}

#Preview {
    HomeView()
}


struct TabButton: View {
    var title: String
    var animation: Namespace.ID
    @Binding var currentTab: String
    var body: some View {
        Button {
            withAnimation(.spring()) {
                currentTab = title
            }
        } label: {
            Text(title)
                .fontWeight(.bold)
                .foregroundStyle(currentTab == title ? .white : .black)
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                .padding(.vertical,8)
                .background(
                    ZStack {
                        if(currentTab == title) {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.black)
                                .matchedGeometryEffect(id: "TAB", in: animation)
                        }
                    }
                )
        }
    }
}
