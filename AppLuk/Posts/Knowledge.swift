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

    static var example1: Knowledge {
        .init(timePosted: .now.addingTimeInterval(-30000),
              postedById: "",
              contentPages:
              [
                  """
                  3 Lý do tại sao nên nuôi 1 (hoặc nhiều) em Australian Shepherd:

                  Lý do số 1: ẻm rất là cuteeeee phô mai queeeeee
                  """,

                  """
                  No one's bolder than me
                  You're bitch like me 'cause I'm braggadocious
                  Call me the prodigy
                  I'm terabyte, you're a lil'
                  Top Dawg that we be
                  This is all vicinity
                  Caress all the titties, hah
                  Think you harder than Wine, Lai and me?
                  Come to Phú Nhuận and you see
                  All them mo'fuckers bị hủy
                  Tài khoản ngân hàng một tỷ
                  Super rich kids flexin'
                  Come and see me at blu
                  """,

                  """
                  Haiz
                  Woah, woah, woah
                  Huh-huh
                  Zui zẻ nhờ?
                  Woah, woah, woah
                  Tam giác là tác giam, tát là đánh, giam là nhốt (woah, woah, woah-woah-woah)
                  Đánh nhốt là đốt nhánh, đốt là thiêu, nhánh là cành
                  Thiêu cành là thank you, thank you everybody, welcome to the party (pow)
                  Mua vé số tao mua cả kí, mua cho My G và mấy ní (pow, pow, pow-pow-pow)
                  Under The Hood, không được thì cút
                  Đừng có lải nhải, đừng có này kia
                  Flow tao iPhone nhưng lời văn tao như là cục gạch Nokia (prrra)
                  Tăng Động ra tay, dang rộng đôi chân (wow)
                  AP never hesitate, one two and I engage (woah, woah)
                  Don't try to-to fuck up the fun
                  MU is red (Rooney)
                  Chelsea is blue (Drogba)
                  If you suck my cu (whoo)
                  I will xoa your vú (ờ đúng rồi)
                  """,
              ],
              imageUrls:
              [
                  "https://cdn.britannica.com/22/234622-050-4D6BD081/Australian-shepherd-dog-red-merle.jpg",
                  nil,
                  "https://as1.ftcdn.net/v2/jpg/04/98/65/04/1000_F_498650403_XfVkkiHQMhoG5DCxACGSvRX0qMSRfyOw.jpg",
              ],
              tags:
              [
                  "dogs",
              ])
    }
}
