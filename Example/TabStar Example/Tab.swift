//
//  Tab.swift
//  TabStar Example
//
//  Created by Bosco Ho on 2023-12-19.
//

import Foundation
import SwiftUI

enum Tab: Int, CaseIterable, Hashable, Identifiable, Comparable, CustomStringConvertible {
    
    static func < (lhs: Tab, rhs: Tab) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
    
    case feed, inbox
    
    var id: Self { self }
    
    var description: String {
        switch self {
        case .feed:
            "Feed"
        case .inbox:
            "Inbox"
        }
    }
    
    var systemImage: String {
        switch self {
        case .feed:
            "list.bullet.rectangle.portrait"
        case .inbox:
            "tray"
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
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
        }
    }
    
    @ViewBuilder
    func tabItemLabel() -> some View {
        Label(description, systemImage: systemImage)
    }
}
