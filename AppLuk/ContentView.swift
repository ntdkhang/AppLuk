//
//  ContentView.swift
//  AppLuk
//
//  Created by Khang Nguyen on 7/28/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        KnowledgeListView()
            .task {
                DataStorageManager.shared.fetchCurrentUser()
            }
    }
}

#Preview {
    ContentView()
}
