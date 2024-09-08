//
//  Comment.swift
//  AppLuk
//
//  Created by Khang Nguyen on 8/21/24.
//

import FirebaseFirestore
import Foundation

struct Comment: Codable, Identifiable {
    @DocumentID var id: String?
    var isReply: Bool = false
    var parentID: String = "" // the id of the parent comment, if current comment is reply comment
    var postedById: String
    var timePosted: Date

    var text: String

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
