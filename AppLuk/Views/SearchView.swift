//
//  SearchView.swift
//  AppLuk
//
//  Created by Khang Nguyen on 8/29/24.
//

import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    var body: some View {
        VStack {
            Form {
                Section {
                    Text("Searching for \(searchText)")
                    Text("Searching for \(searchText)")
                    Text("Searching for \(searchText)")
                }

                Section {
                }
            }
        }
        .searchable(text: $searchText)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background)
    }
}
