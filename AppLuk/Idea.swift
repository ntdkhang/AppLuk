//
//  Idea.swift
//  AppLuk
//
//  Created by Khang Nguyen on 8/2/24.
//

import Foundation

struct Idea {
    var timePosted: Date
    var postedBy: String

    var tldr: String?
    var content: String

    var wordCount: Int {
        content.count
    }

    var replies: [Idea]


    var previewContent: String {
        if (wordCount < 280) {
            return content
        }
        let index = content.index(content.startIndex, offsetBy: 280)
        return String(content[...index])
    }

    static var example: Idea {
        .init(timePosted: .now.addingTimeInterval(-100000), postedBy: "MDK", tldr: "Ai so thi di ve", content:
        """
        ## Giờ có làm không
        Có tiền là được
        Một hai ba lên nhạc

        [Verse 1]
        Có thằng em bị dí ở trên Tông Đản
        Alo, thôi em thông cảm (Anh bận lắm)
        Nó gọi cho vài anh em trông bản
        Và mọi thứ trở nên không đơn giản
        Anh có lỗi vì đã quên không cản (Anh thấy có lỗi quá)
        Anh có lỗi vì đã quên không cản (Lỗi, lỗi bên anh)

        Nhận ra mình đang ở quận ba đình
        Quay đầu thấy
        Mấy thằng em đứng ở ngay cầu giấy
        Sống phải bó cẩn không là bay màu đấy
        Nếu muốn trơn tru thì phải đi thay dầu máy
        Nhạc lên là phải căng
        Lấy đồ giá cả phải chăng
        Gái mà ngon là phải chăn
        Bố mày sáng như hải đăng (Bitch, yuh!)

        Không có thời gian để giải oan
        Muốn có được anh thì phải ngoan
        Lướt trong bóng tối như là ninja
        Sáng dậy biến mất và cải trang
        Em ấy thốt lên là 진짜
        Thế mà tao cứ tưởng là đài loan
        Tao chỉ nắm tay thôi
        Nhưng mà em ý bảo là phải phang
        Không, anh không
        Em muốn có anh thì khó lắm
        Tại anh chảnh chó lắm
        Nhưng mà anh muốn có em thì lại nhanh không
        Tay, để ở quanh hông
        Nhiều nước, hanh thông
        Làm 1 bài khèn đi cho anh cuấn điếu
        Vèo cái, nhanh không
        Kí tặng fan, tên là Đạt
        Nhà nó có hồ bơi ngay ở trên Đà Lạt
        Trên cổ anh, toàn là đá
        Đây là gì à? Đây là nhạc
        Check the bank đi, bao nhiêu số?
        Mày khoe làm gì? Thôi mày cất vào đê
        Ben to, rất là phê
        Mày mặc xấu vãi, rất nhà quê

        [Hook]
        Phong cách, phong cách
        Phong cách, phong cách
        Phong cách, phong cách
        Phong cách
        (Bitch)
        Phong cách, phong cách
        Phong cách, phong cách
        Phong cách, phong cách
        [Verse 2]
        (Ok)
        Ok chưa? Ok lah!
        Mấy cái thằng ngu thì rất hay là khè bửn
        Chúng nó muốn xỏ thử vào đôi giày của tao
        Tao chỉ thở dài nhìn đôi Bottega
        Đang đi ăn, đôi khi phải bịt mặt như là Taliban
        Sợ mấy thằng fan chúng nó đang đi săn
        Cảm thấy cô độc đứng trên đỉnh Phan Xi Păng

        Bọn lít nhít
        Bố mày nhai mày như là Chip Chip
        Bố mày ỉa ra một bãi mày vào hít hít
        Rap cái kiểu đéo gì suốt ngày đít đít
        Drip drip, lit lit
        Tưởng là ngáo ngáo gọi là trip trip
        Gọi cho thằng bạn tao gạ là feat feat
        Bọn tao đéo thèm nghe luôn gọi là tít tít

        [Hook]
        (Phong cách, phong cách
         Phong cách, phong cách
         Phong cách, phong cách) (Ok)

        """, replies: [])
    }
}

