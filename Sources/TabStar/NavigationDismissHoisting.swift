//
//  NavigationDismissHoisting.swift
//  TabStar
//
//  Created by Bosco Ho on 2023-12-19.
//

import SwiftUI

// MARK: - Hoist dismiss action
public extension View {
    
    /// - Parameter dismiss: Pass in the `@Environment(\.dismiss)` property declared in the view being modified.
    /// - Note: See `hoistNavigation(_ primaryAction:...)`, if declaring dismiss action in your view causes SwiftUI to enter an infinite loop.
    func hoistNavigation(
        dismiss: DismissAction,
        auxiliaryAction: Navigation.AuxiliaryAction? = nil
    ) -> some View {
        // TODO: Possibly allow injection. If not, deprecate and remove this function.
        modifier(
            NavigationDismissHoisting(
                auxiliaryAction: auxiliaryAction
            )
        )
    }
    
    /// This view modifier variant manages the primary action on behalf of caller.
    ///
    /// In some view configurations, declaring the `@Environment(\.dismiss)` property may cause SwiftUI to enter an infinite loop. If so, use this view modifier, instead.
    func hoistNavigation(
        _ primaryAction: Navigation.PrimaryAction = .dismiss,
        auxiliaryAction: Navigation.AuxiliaryAction? = nil
    ) -> some View {
        modifier(
            NavigationDismissHoisting(
                auxiliaryAction: auxiliaryAction
            )
        )
    }
}

internal struct NavigationDismissHoisting: ViewModifier {
    
    private typealias AnyRoute = any Hashable
    
    @EnvironmentObject private var navigation: Navigation
    @Environment(\.navigationPathCount) private var pathCount
    
    let auxiliaryAction: Navigation.AuxiliaryAction?
    
    @State private var didAppear = false
    
    func body(content: Content) -> some View {
        NavigationDismissView { dismiss in
            content
                .onAppear {
                    defer { didAppear = true }
                    
                    /// This must only be called once:
                    /// For example, user may wish to drag to peek at the previous view, but then cancel that drag action. During this, the previous view's .onAppear will get called. If we run this logic for that view again, the actual top view's dismiss action will get lost. [2023.09]
                    if didAppear == false {
#if DEBUG
                        print("onAppear: hoist navigation dismiss action")
#endif
                        navigation.dismiss = dismiss
                        navigation.auxiliaryAction = auxiliaryAction
                        let pathIndex = max(0, pathCount)
#if DEBUG
                        print("     adding path action at index -> \(pathIndex)")
#endif
                        navigation.pathActions[pathIndex] = (dismiss, auxiliaryAction)
#if DEBUG
                        print("     navigation -> \(Unmanaged.passUnretained(navigation).toOpaque())")
#endif
                    }
                }
                .onDisappear {
#if DEBUG
                    print("onDisappear: path count -> \(pathCount), action count -> \(navigation.pathActions.count)")
                    print("     navigation -> \(Unmanaged.passUnretained(navigation).toOpaque())")
#endif
                    
                    let removeIndex = pathCount + 1
                    // swiftlint:disable unused_optional_binding
                    if let _ = navigation.pathActions.removeValue(forKey: removeIndex) {
#if DEBUG
                        // swiftlint:enable unused_optional_binding
                        print("     removed path action at index -> \(removeIndex)")
#endif
                    } else {
#if DEBUG
                        print("     no path action to remove at index -> \(removeIndex)")
#endif
                    }
                }
        }
    }
}
