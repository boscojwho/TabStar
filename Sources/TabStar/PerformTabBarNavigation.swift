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
    func tabBarNavigationEnabled<TabSelection: Hashable>(
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

public struct PerformTabBarNavigation<TabSelection: Hashable>: ViewModifier {
            
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
