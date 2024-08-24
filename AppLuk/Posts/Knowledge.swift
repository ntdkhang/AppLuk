//
//  Knowledge.swift
//  AppLuk
//
//  Created by Khang Nguyen on 8/2/24.
//

import FirebaseFirestore
import Foundation

struct Knowledge: Codable, Identifiable {
    @DocumentID var id: String?
    var timePosted: Date = .now
    var postedById: String

    var contentPages: [String]

    // Every contentPage needs to have a corresponding image. The image could be null, in that case, we'll use a black background
    var imageUrls: [String?] // images.length == contentPage.length

    var tags: [String] = []

    var relativeTimeString: String {
        var formatStyle = Date.RelativeFormatStyle()
        formatStyle.presentation = .numeric
        formatStyle.unitsStyle = .narrow

        if timePosted.timeIntervalSinceNow > -60 {
            return "1m"
        }
        return String(formatStyle.format(timePosted).dropLast(3)) // drop the "ago" string
    }
}
