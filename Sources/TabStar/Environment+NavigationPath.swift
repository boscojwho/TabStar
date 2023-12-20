//
//  Environment+NavigationPath.swift
//  TabStar
//
//  Created by Bosco Ho on 2023-12-19.
//

import SwiftUI

public struct NavigationPathCountEnvironmentKey: EnvironmentKey {
    public static let defaultValue: Int = 0
}

public extension EnvironmentValues {
    var navigationPathCount: Int {
        get { self[NavigationPathCountEnvironmentKey.self] }
        set { self[NavigationPathCountEnvironmentKey.self] = newValue }
    }
}
