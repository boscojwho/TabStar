//
//  FeedView.swift
//  TabStar Example
//
//  Created by Bosco Ho on 2023-12-18.
//

import SwiftUI
import TabStar

struct FeedView: View {
    
    @StateObject private var navigation: Navigation = .init()
    @State private var navigationPath: NavigationPath = .init()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ScrollViewReader { scrollProxy in
                ScrollView {
                    VStack {
                        Text("Feed View")
                            .id("top")
                        
                        ForEach(0..<100) { value in
                            Text("\(value)")
                        }
                        
                        NavigationLink(value: "Detail") {
                            Text("Go to detail...")
                        }
                    }
                    .containerRelativeFrame(.horizontal)
                }
                .tabBarNavigationEnabled(Tab.feed, navigation)
                .environment(\.navigationPathCount, navigationPath.count)
                .hoistNavigation {
                    withAnimation {
                        scrollProxy.scrollTo("top")
                    }
                    return true
                }
                .navigationDestination(for: String.self) { value in
                    FeedDetailView()
                        .hoistNavigation()
                }
            }
        }
        .environment(\.navigationPathCount, navigationPath.count)
        .environmentObject(navigation)
    }
}

#Preview {
    FeedView()
}
