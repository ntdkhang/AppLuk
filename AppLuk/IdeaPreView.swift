//
//  IdeaPreView.swift
//  AppLuk
//
//  Created by Khang Nguyen on 8/2/24.
//

import SwiftUI
import MarkdownUI

struct IdeaPreView: View {
    var idea: Idea
    var body: some View {
        VStack {
            HStack {
                Markdown(idea.previewContent)
            }
        }
    }

}

