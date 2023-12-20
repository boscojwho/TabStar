//
//  ContentView.swift
//  TabStar Example
//
//  Created by Bosco Ho on 2023-12-18.
//

import SwiftUI
import TabStar

@Observable
final class TabSelectionViewModel {
    var selectedTab: Tab = .feed
    var reselectedTab: Tab?
}

struct ContentView: View {
    
    @State private var tabSelection: TabSelectionViewModel = .init()
    
    private var selection: Binding<Tab> {
        .init {
            tabSelection.selectedTab
        } set: { newValue in
            tabSelection.selectedTab = newValue
        }.onUpdate { old, new in
            /// Trigger reselect update.
            if old == new {
                tabSelection.reselectedTab = new
            }
        }
    }
    
    var body: some View {
        TabView(selection: selection) {
            ForEach(Tab.allCases) { tab in
                tab.makeRootView()
                    .tabItem { tab.tabItemLabel() }
                    .tag(tab.hashValue)
                    .environment(\.tabSelectionId, tabSelection.selectedTab.rawValue)
                    .environment(\.tabReselectionId, tabSelection.reselectedTab?.rawValue)
            }
        }
        .onChange(of: tabSelection.reselectedTab) { _, newValue in
            // Resets the reselection value to nil after the change is published, otherwise subsequent reselects won't trigger onChange updates.
            if newValue != nil {
                tabSelection.reselectedTab = nil
            }
        }
    }
}

#Preview {
    ContentView()
}
