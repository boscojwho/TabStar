//
//  InboxDetailView.swift
//  TabStar Example
//
//  Created by Bosco Ho on 2023-12-20.
//

import SwiftUI

struct InboxDetailView: View {
    var body: some View {
        VStack {
            Text("Inbox Detail View")
            NavigationLink(value: InboxPath.detail) {
                Text("Go to detail...")
            }
        }
    }
}

#Preview {
    InboxDetailView()
}
