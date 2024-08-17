//
//  ContentView.swift
//  AppLuk
//
//  Created by Khang Nguyen on 7/28/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        KnowledgeView(knowledge: .example1)
            .task {
            }
    }
}

#Preview {
    ContentView()
}
