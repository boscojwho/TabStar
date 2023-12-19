//
//  ContentView.swift
//  TabStar Example
//
//  Created by Bosco Ho on 2023-12-18.
//

import SwiftUI
import TabStar

enum Tab: CaseIterable, Identifiable, CustomStringConvertible {
    case feed, inbox, search

    var id: Self { self }

    var description: String {
        switch self {
        case .feed:
            "Feed"
        case .inbox:
            "Inbox"
        case .search:
            "Search"
        }
    }
    
    var systemImage: String {
        switch self {
        case .feed:
            "list.bullet.rectangle.portrait"
        case .inbox:
            "tray"
        case .search:
            "magnifyingglass"
        }
    }
}

extension Tab {
    
    @ViewBuilder
    func makeRootView() -> some View {
        switch self {
        case .feed:
            FeedView()
        case .inbox:
            InboxView()
        case .search:
            SearchView()
        }
    }
    
    @ViewBuilder
    func tabItemLabel() -> some View {
        Label(description, systemImage: systemImage)
    }
}

@Observable
final class TabSelectionViewModel {
    var selectedTab: Tab = .feed
}

struct ContentView: View {
    
    @State private var tabSelection: TabSelectionViewModel = .init()
    
    var body: some View {
        TabView(selection: $tabSelection.selectedTab) {
            ForEach(Tab.allCases) { tab in
                tab.makeRootView()
                    .tabItem { tab.tabItemLabel() }
                    .tag(tab.hashValue)
            }
        }
    }
}

#Preview {
    ContentView()
}
