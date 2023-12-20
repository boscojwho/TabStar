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
            VStack {
                Text("Feed View")
                NavigationLink(value: "Detail") {
                    Text("Go to detail...")
                }
            }
            .tabBarNavigationEnabled(Tab.feed, navigation)
            .environment(\.navigationPathCount, navigationPath.count)
            .hoistNavigation()
            .navigationDestination(for: String.self) { value in
                FeedDetailView()
                    .hoistNavigation()
            }
        }
        .environment(\.navigationPathCount, navigationPath.count)
        .environmentObject(navigation)
    }
}

#Preview {
    FeedView()
}
