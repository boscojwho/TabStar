//
//  Environment+TabSelection.swift
//  TabStar
//
//  Created by Bosco Ho on 2023-12-19.
//

import SwiftUI

// MARK: - Selection
public struct TabSelectionEnvironmentKey: EnvironmentKey {
    public static var defaultValue: Int? { nil }
}

public extension EnvironmentValues {
    /// A value representing a tab's identity.
    var tabSelectionId: Int? {
        get { self[TabSelectionEnvironmentKey.self] }
        set { self[TabSelectionEnvironmentKey.self] = newValue }
    }
}

// MARK: - Reselection
public struct TabReselectionEnvironmentKey: EnvironmentKey {
    public static var defaultValue: Int? { nil }
}

public extension EnvironmentValues {
    /// A value representing a tab's identity.
    var tabReselectionId: Int? {
        get { self[TabReselectionEnvironmentKey.self] }
        set { self[TabReselectionEnvironmentKey.self] = newValue }
    }
}
