//
//  NavigationContext.swift
//  TabStar
//
//  Created by Bosco Ho on 2023-09-08.
//

import Foundation

/// You may wish to vary how to construct a `NavigationLink` or any other SwiftUI Navigation construct for a variety of reasons.
public enum NavigationContext {
    /// When presented inside a `NavigationSplitView` sidebar.
    case sidebar
    /// When presented in any view.
    case view
}
