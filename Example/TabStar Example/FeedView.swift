//
//  FeedView.swift
//  TabStar Example
//
//  Created by Bosco Ho on 2023-12-18.
//

import SwiftUI
import TabStar

struct FeedView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    @StateObject private var navigation: Navigation = .init()
    @State private var navigationPath: NavigationPath = .init()
    @State private var sidebarSelection: Int?
    @State private var columnVisibility: NavigationSplitViewVisibility = .automatic
    @State private var scrollToTopAppeared = false
    
    @Namespace var scrollToTop

    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            List(selection: $sidebarSelection) {
                ForEach(0..<30) { value in
                    Text("\(value)")
                }
            }
        } detail: {
            NavigationStack(path: $navigationPath) {
                Group {
                    ScrollViewReader { scrollProxy in
                        ScrollView {
                            LazyVStack {
                                Text("Feed View")
                                    .id(scrollToTop)
                                    .onAppear {
                                        scrollToTopAppeared = true
                                    }
                                    .onDisappear {
                                        scrollToTopAppeared = false
                                    }
                                
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
                            if navigationPath.isEmpty {
                                /// Need to check `scrollToTopAppeared` because we want to scroll to top before popping back to sidebar. [2023.09]
                                if scrollToTopAppeared {
                                    if horizontalSizeClass == .regular {
                                        print("show/hide sidebar in regular size class")
                                        columnVisibility = {
                                            /// Show/hide sidebar (e.g. iPad) by toggling between `.detailOnly` and `.all`.
                                            if columnVisibility == .all {
                                                return .detailOnly
                                            } else {
                                                return .all
                                            }
                                        }()
                                        return true
                                    } else {
                                        print("show/hide sidebar in compact size class")
                                        // This seems a lot more reliable than dismiss action for some reason. [2023.09]
                                        self.sidebarSelection = nil
                                        return true
                                        //                                // Return `false` to use dismiss action to go back to sidebar. Not sure
                                        //                                return false
                                    }
                                } else {
                                    print("scroll to top")
                                    withAnimation {
                                        scrollProxy.scrollTo(scrollToTop)
                                    }
                                    return true
                                }
                            } else {
                                if scrollToTopAppeared {
                                    print("exhausted auxiliary actions, perform dismiss action instead...")
                                    return false
                                } else {
                                    withAnimation {
                                        scrollProxy.scrollTo(scrollToTop)
                                    }
                                    return true
                                }
                            }
                        }
                        .navigationDestination(for: String.self) { value in
                            FeedDetailView()
                        }
                    }
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
