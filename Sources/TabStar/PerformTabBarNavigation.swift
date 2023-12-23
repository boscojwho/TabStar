//
//  PerformTabBarNavigation.swift
//  TabStar
//
//  Created by Bosco Ho on 2023-09-08.
//

import Foundation
import SwiftUI

// MARK: - Enable tab bar navigation
public extension View {
    
    /// Unconditionally enable tab bar navigation.
    /// - Parameter playSensoryFeedback: If your app runs on OS versions that don't support `View.sensoryFeedback(...)`, perform haptic playback inside this closure whenever tab bar item is tapped.
    func tabBarNavigationEnabled<TabSelection: Hashable & CustomStringConvertible>(
        _ tab: TabSelection,
        _ navigator: Navigation,
        playSensoryFeedback: (() -> Void)? = nil
    ) -> some View {
        modifier(
            PerformTabBarNavigation(
                tab: tab,
                navigator: navigator,
                playSensoryFeedback: playSensoryFeedback
            )
        )
    }
}

public struct PerformTabBarNavigation<TabSelection: Hashable & CustomStringConvertible>: ViewModifier {
            
    @Environment(\.navigationPathCount) private var pathCount
    @Environment(\.tabSelectionId) private var selectedTabId
    @Environment(\.tabReselectionId) private var reselectedTabId
    
    let tab: TabSelection
    let navigator: Navigation
    let playSensoryFeedback: (() -> Void)?
    
    public func body(content: Content) -> some View {
        content
            .onChange(of: reselectedTabId) { newValue in
                if newValue == tab.hashValue {
                    // Customization based on user preference should occur here, for example:
                    // performSystemPopToRootBehaviour()
                    // noOp()
                    // performDimsissOnly()
                    performDismissAfterAuxiliary()
                }
            }
            ._sensoryFeedback(
                navigator.sensoryFeedback,
                trigger: reselectedTabId == tab.hashValue,
                playSensoryFeedback: playSensoryFeedback
            )
    }
    
    /// Runs all auxiliary actions before calling system dismiss action.
    private func performDismissAfterAuxiliary() {
        Log.default.debug("perform action on path index -> \(pathCount)")
        
        guard let pathAction = navigator.pathActions[pathCount] else {
            Log.default.debug("path action not found at index -> \(pathCount)")
            return
        }
        
        if let auxiliaryAction = pathAction.auxiliaryAction {
            let performed = auxiliaryAction()
            if !performed, let dismiss = pathAction.dismiss {
                Log.default.debug("found auxiliary action, but that logic has been exhausted...perform standard dismiss action")
                Log.default.debug("perform tab navigation on \(tab) tab")
                dismiss()
            } else {
                Log.default.debug("performed auxiliary action")
            }
        } else if let dismiss = pathAction.dismiss {
            Log.default.debug("perform dismiss action via tab navigation on \(tab) tab")
            dismiss()
        } else {
            Log.default.debug("attempted tab navigation -> action(s) not found")
        }
    }
}
