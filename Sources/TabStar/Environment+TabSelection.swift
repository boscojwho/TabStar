//
//  Environment+TabSelection.swift
//  TabStar
//
//  Created by Bosco Ho on 2023-12-19.
//

import SwiftUI

// MARK: - Selection
struct TabSelectionEnvironmentKey: EnvironmentKey {
    static var defaultValue: Int? { nil }
}

extension EnvironmentValues {
    var tabSelectionHashValue: Int? {
        get { self[TabSelectionEnvironmentKey.self] }
        set { self[TabSelectionEnvironmentKey.self] = newValue }
    }
}

// MARK: - Reselection
struct TabReselectionEnvironmentKey: EnvironmentKey {
    static var defaultValue: Int? { nil }
}

extension EnvironmentValues {
    var tabReselectionHashValue: Int? {
        get { self[TabReselectionEnvironmentKey.self] }
        set { self[TabReselectionEnvironmentKey.self] = newValue }
    }
}
