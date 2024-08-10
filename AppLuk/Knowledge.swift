//
//  Idea.swift
//  AppLuk
//
//  Created by Khang Nguyen on 8/2/24.
//

import Foundation

struct Knowledge: Identifiable {
    var id: UUID = UUID()
    var timePosted: Date = .now
    var postedBy: User

    var contentPages: [String] // each index is the string of content on one page. What's the limit for word count?

    // Every contentPage needs to have a corresponding image. The image could be null, in that case, we'll use a black background
    var images: [URL?] // images.length == contentPage.length

    var relativeTimeString: String {
        var formatStyle = Date.RelativeFormatStyle()
        formatStyle.presentation = .numeric
        formatStyle.unitsStyle = .narrow
        // TODO: if smaller than 1 minute, round up to 1 minute
        return String(formatStyle.format(timePosted).dropLast(3)) // drop the "ago" string
    }

    static var example1: Knowledge {
        .init(timePosted: .now.addingTimeInterval(-30000), postedBy: .example_DK, contentPages:
            [
                """
                3 Lý do tại sao nên nuôi 1 (hoặc nhiều) em Australian Shepherd:
                Lý do số 1: ẻm rất là cuteeeee phô mai queeeeee
                """,
                """
                Lý do số 2: ẻm rất thông minh
                """,
                """
                Lý do số 3: ẻm rất năng động và khoẻ khoắn
                """,
            ],
            images:
            [
                URL(string: "https://cdn.britannica.com/22/234622-050-4D6BD081/Australian-shepherd-dog-red-merle.jpg"),
                nil,
                URL(string: "https://as1.ftcdn.net/v2/jpg/04/98/65/04/1000_F_498650403_XfVkkiHQMhoG5DCxACGSvRX0qMSRfyOw.jpg"),
            ])
    }
}
