//
//  FeedDetailView.swift
//  TabStar Example
//
//  Created by Bosco Ho on 2023-12-19.
//

import SwiftUI

struct FeedDetailView: View {
    
    var body: some View {
        VStack {
            Text("Feed Detail View")
            NavigationLink(value: "Detail") {
                Text("Go to detail...")
            }
        }
    }
}


#Preview {
    FeedDetailView()
}
