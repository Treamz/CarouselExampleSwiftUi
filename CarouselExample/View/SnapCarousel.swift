//
//  SnapCarousel.swift
//  CarouselExample
//
//  Created by Иван Чернокнижников on 22.01.2024.
//

import SwiftUI


// Accepting list...
struct SnapCarousel<Content: View, T: Identifiable>: View {
    var content: (T) -> Content
    var list: [T]
    
    
    // Properties
    var spacing: CGFloat
    var trailingSpace: CGFloat
    
    @Binding var index: Int
    
    // Offset..
    @GestureState var offset: CGFloat = 0
    @State var currentIndex: Int = 0
     

    
    
    init(spacing: CGFloat = 15,trailingSpace: CGFloat = 100, index: Binding<Int>,items: [T], @ViewBuilder content: @escaping (T)->Content) {
        self.list = items
        self.spacing = spacing
        self.trailingSpace = trailingSpace
        self._index = index
        self.content = content
    }
    
    var body: some View {
        GeometryReader { proxy in
            
            // Setting correct width for snap item
            
            // One sided snap carousel
            let width = proxy.size.width - (trailingSpace - spacing)
            
            let adjustingMentWidth = (trailingSpace / 2) - spacing
            HStack(spacing:spacing) {
                ForEach(list) { item in
                    
                    content(item)
                        .frame(width: proxy.size.width - trailingSpace)
                }
            }
            .padding()
            .offset(x: (CGFloat(currentIndex) * -width) + (currentIndex != 0 ? adjustingMentWidth : 0) + offset)
            .gesture(
                DragGesture()
                    .updating($offset , body: { value, out, _ in
                        out = value.translation.width
                
                    })
                    .onEnded({value in
                        
                        // Updating current index
                        
                        let offsetX = value.translation.width
                        
                        // convert translation into progress
                        // and round
                        // based on the progress increas/decrease currentIndex
                        let progress = -offsetX / width
                        let roundIndex = progress.rounded()
                        
                        // setting max
                        currentIndex = max(min(currentIndex + Int(roundIndex), list.count - 1), 0)
                        
                        currentIndex = index
                    })
                    .onChanged({ value in
                        // updating only index
                        // Updating current index
                        
                        let offsetX = value.translation.width
                        
                        // convert translation into progress
                        // and round
                        // based on the progress increas/decrease currentIndex
                        let progress = -offsetX / width
                        let roundIndex = progress.rounded()
                        
                        // setting max
                        index = max(min(currentIndex + Int(roundIndex), list.count - 1), 0)
                    })
                
            )
        }
        // Animation when offset = 0
        .animation(.easeInOut,value: offset ==  0)
    }
}

#Preview {
    HomeView()
}
