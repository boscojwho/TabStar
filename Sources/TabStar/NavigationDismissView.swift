//
//  NavigationDismissView.swift
//  TabStar
//
//  Created by Bosco Ho on 2023-12-19.
//

import SwiftUI

/// `NavigationDismissView` works around an issue where adding an `@Environment(\.dismiss)` property in some view configurations causes SwiftUI to enter infinite loop.
///
/// Technical Note:
/// - Note: In some configurations, declaring the `@Environment(\.dismiss) var` inside a view modifier causes SwiftUI to enter into infinite loop. [2023.09]
/// - Note: This view allows us to conditionally move where we declare the dismiss action, if some view (modifier) configuration causes SwiftUI to enter infinite loop. [2023.11]
private struct NavigationDismissView<Content: View>: View {
    
    @Environment(\.dismiss) private var dismissAction
    private let content: (DismissAction) -> Content
    
    init(@ViewBuilder content: @escaping (DismissAction) -> Content) {
        self.content = content
    }
    
    var body: some View {
        content(dismissAction)
    }
}
