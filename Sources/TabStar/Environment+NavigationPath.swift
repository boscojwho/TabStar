//
//  Environment+NavigationPath.swift
//  TabStar
//
//  Created by Bosco Ho on 2023-12-19.
//

import SwiftUI

private struct NavigationPathEnvironmentKey: EnvironmentKey {
    static let defaultValue: Binding<[any Hashable]> = .constant([])
}

extension EnvironmentValues {
    var navigationPath: Binding<[any Hashable]> {
        get { self[NavigationPathEnvironmentKey.self] }
        set { self[NavigationPathEnvironmentKey.self] = newValue }
    }
}
