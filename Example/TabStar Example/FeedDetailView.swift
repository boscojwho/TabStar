//
//  FeedDetailView.swift
//  TabStar Example
//
//  Created by Bosco Ho on 2023-12-19.
//

import SwiftUI
import TabStar

struct FeedDetailView: View {
    
    @Namespace var scrollToTop
    @State private var scrolledToTop = false
    
    var body: some View {
        ScrollViewReader { scrollProxy in
            ScrollView {
                LazyVStack {
                    Text("Feed Detail View")
                        .id(scrollToTop)
                        .onAppear {
                            scrolledToTop = true
                        }
                        .onDisappear {
                            scrolledToTop = false
                        }
                    
                    ForEach(0..<50) { value in
                        Text("\(value)")
                    }
                    
                    NavigationLink(value: "Detail") {
                        Text("Go to detail...")
                    }
                }
            }
            .hoistNavigation {
                if scrolledToTop {
                    return false
                } else {
                    withAnimation {
                        scrollProxy.scrollTo(scrollToTop)
                    }
                    return true
                }
            }
        }
    }
}

#Preview {
    FeedDetailView()
}
