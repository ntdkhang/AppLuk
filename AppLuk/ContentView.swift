//
//  ContentView.swift
//  AppLuk
//
//  Created by Khang Nguyen on 7/28/24.
//

import SwiftUI

struct ContentView: View {
    @State private var tabSelection = 0
    var body: some View {
        NavigationStack {
            ZStack {
                KnowledgeListView()

                VStack {
                    NavigationLink {
                        SearchKnowledgeView()
                    } label: {
                        Text("Test")
                    }
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
            }
        }
    }
}
