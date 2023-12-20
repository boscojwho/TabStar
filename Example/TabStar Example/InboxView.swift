//
//  InboxView.swift
//  TabStar Example
//
//  Created by Bosco Ho on 2023-12-18.
//

import SwiftUI
import TabStar

enum InboxPath: Hashable {
    case detail
}

struct InboxView: View {
    
    @StateObject private var navigation: Navigation = .init()
    @State private var navigationPath: [InboxPath] = []
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack {
                Text("Inbox View")
                NavigationLink(value: InboxPath.detail) {
                    Text("Go to detail...")
                }
            }
            .tabBarNavigationEnabled(Tab.inbox, navigation)
            .environment(\.navigationPathCount, navigationPath.count)
            .hoistNavigation()
            .navigationDestination(for: InboxPath.self) { value in
                InboxDetailView()
                    .hoistNavigation()
            }
        }
        .environment(\.navigationPathCount, navigationPath.count)
        .environmentObject(navigation)
    }
}

#Preview {
    InboxView()
}
