//
//  Knowledge.swift
//  AppLuk
//
//  Created by Khang Nguyen on 8/2/24.
//

import FirebaseFirestore
import Foundation

struct Knowledge: Codable, Identifiable, Equatable {
    @DocumentID var id: String?
    var timePosted: Date = .now
    var postedById: String

    var title: String

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

    var contentPagesWithTags: [String] {
        if tags.isEmpty {
            return contentPages
        } else {
            var temp = contentPages
            var newPage: String = ""
            for tag in tags {
                newPage.append("#" + tag + " ")
            }
            temp.append(newPage)
            return temp
        }
    }

    var imageUrlsWithTags: [String?] {
        if tags.isEmpty {
            return imageUrls
        } else {
            var temp = imageUrls
            temp.append(nil)
            return temp
        }
    }

    var isCurrentUserPosted: Bool {
        return postedById == DataStorageManager.shared.currentUserId
    }

    static var tags: [String] {
        return [
            "Mental",
            "Spiritual",
            "Art",
            "Social",
            "Toolset",
            "Skillset",
            "Mindset",
            "Mindfulness",
            "Book",
            "Fact",
            "ScientificResearch",
            "Course",
            "Survival",
            "Tips",
            "Cooking",
            "Handcraft",
            "Language",
            "Human",
            "Healthcare",
            "Influencer",
            "Beautycare",
            "Sport",
            "SoftSkills",
            "Others",
        ]
        .sorted()
    }

    static var empty: Knowledge {
        return Knowledge(postedById: "0KBb2kjXOkVQtpxUjkXg2Ss4aZA2", title: "you're not supposed to see this", contentPages: [""], imageUrls: [])
    }
}
