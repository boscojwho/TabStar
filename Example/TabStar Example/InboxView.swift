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
            ScrollViewReader { scrollProxy in
                ScrollView {
                    VStack {
                        Text("Inbox View")
                            .id("top")
                        
                        ForEach(0..<100) { value in
                            Text("\(value)")
                        }
                        
                        NavigationLink(value: InboxPath.detail) {
                            Text("Go to detail...")
                        }
                    }
                    .containerRelativeFrame(.horizontal)
                }
                .tabBarNavigationEnabled(Tab.inbox, navigation)
                .hoistNavigation {
                    withAnimation {
                        scrollProxy.scrollTo("top")
                    }
                    return true
                }
                .navigationDestination(for: InboxPath.self) { value in
                    InboxDetailView()
                        .hoistNavigation()
                }
            }
        }
        .environment(\.navigationPathCount, navigationPath.count)
        .environmentObject(navigation)
    }
}

#Preview {
    InboxView()
}
