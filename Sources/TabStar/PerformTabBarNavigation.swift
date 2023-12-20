//
//  PerformTabBarNavigation.swift
//  TabStar
//
//  Created by Bosco Ho on 2023-09-08.
//

import Dependencies
import Foundation
import SwiftUI

// MARK: - Enable tab bar navigation
public extension View {
    
    /// Unconditionally enable tab bar navigation.
    func tabBarNavigationEnabled<TabSelection: Hashable>(_ tab: TabSelection, _ navigator: Navigation) -> some View {
        modifier(PerformTabBarNavigation(tab: tab, navigator: navigator))
    }
}

public struct PerformTabBarNavigation<TabSelection: Hashable>: ViewModifier {
        
//    @Dependency(\.hapticManager) private var hapticManager
    
    @Environment(\.navigationPathCount) private var pathCount
    @Environment(\.tabSelectionId) private var selectedTabId
    @Environment(\.tabReselectionId) private var reselectedTabId
    
    let tab: TabSelection
    let navigator: Navigation
    
    public func body(content: Content) -> some View {
        content.onChange(of: reselectedTabId) { newValue in
            if newValue == tab.hashValue {
//                hapticManager.play(haptic: .gentleInfo, priority: .high)
                // Customization based  on user preference should occur here, for example:
                // performSystemPopToRootBehaviour()
                // noOp()
                // performDimsissOnly()
                performDismissAfterAuxiliary()
            }
        }
    }
    
    /// Runs all auxiliary actions before calling system dismiss action.
    private func performDismissAfterAuxiliary() {
        #if DEBUG
        print("perform action on path index -> \(pathCount)")
        #endif
        guard let pathAction = navigator.pathActions[pathCount] else {
            #if DEBUG
            print("path action not found at index -> \(pathCount)")
            #endif
            return
        }
        
        if let auxiliaryAction = pathAction.auxiliaryAction {
            let performed = auxiliaryAction()
            if !performed, let dismiss = pathAction.dismiss {
                #if DEBUG
                print("found auxiliary action, but that logic has been exhausted...perform standard dismiss action")
                print("perform tab navigation on \(tab) tab")
                #endif
                dismiss()
            } else {
                #if DEBUG
                print("performed auxiliary action")
                #endif
            }
        } else if let dismiss = pathAction.dismiss {
            #if DEBUG
            print("perform dismiss action via tab navigation on \(tab) tab")
            #endif
            dismiss()
        } else {
            #if DEBUG
            print("attempted tab navigation -> action(s) not found")
            #endif
        }
    }
}
