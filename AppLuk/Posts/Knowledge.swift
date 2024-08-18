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
    var imageUrls: [URL?] // images.length == contentPage.length

    var tags: [String] = []

    var comments: [Comment] = []

    var relativeTimeString: String {
        var formatStyle = Date.RelativeFormatStyle()
        formatStyle.presentation = .numeric
        formatStyle.unitsStyle = .narrow
        // TODO: if smaller than 1 minute, round up to 1 minute
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
                Ey, it's AP, woo!
                Jump in the pit
                Jump in the pit
                Jump in the pit, hoh (hoh)
                Face on her tits
                Face on her tits
                Face on her tits, woah (woo)
                No one's bolder than me
                You're bitch like me 'cause I'm braggadocious
                Call me the prodigy
                I'm terabyte, you're a lil' bit
                I jump in this big, get a hold of this bitch
                Take care of the nest, lay low for a minute
                Now I'm back and better, I'm hot need no sweater
                Margiela and feather, I'm going gorilla
                Fuck it, I don't need your two cents, got the hands in my pants
                Pay all my debts do my dance, sharp like mofuckin' lance
                Vô trong phòng đừng bật đèn
                Quên mua bao hơi xì quẽn, đi cúng dừa quên mang nhang (sheesh!)
                Ọc ọc ọc ọc ọc ọc
                Anh em tao đi nhảy (đi nhảy), nọc nọc nọc
                When we drippin' you here, tỏn tỏn tỏn, ey (oh-oh)
                Đấm chết thằng nào nói tao ăn cắp flow của Baby Keem nha
                Tao viết trước bài này cả tháng, con mẹ mày luôn à
                Jump in the pit
                Hai đôi chân bắt chéo, một pha cắt kéo rất lắc léo
                Anh em cột chèo đi lộn mèo
                Đi tìm hiểu cấu trúc của gấu trúc
                Em minơ có màn hình như là tàng hình
                Em thấy anh điện ảnh mà em điện ảnh
                Đau khổ, anh độn thổ, nên anh lộn cổ
                If you pull up to my crib, hờ hờ (lộn chỗ), lộn chỗ
                Đang canh em bé
                Đang canh em bé
                Đang canh em bé, hoh
                Coi chừng bị vấp
                Coi chừng bị té
                Coi chừng bị què, hoh
                No one's bolder than me
                You're bitch like me 'cause I'm braggadocious
                Call me the prodigy
                I'm terabyte, you're a lil' (hah)
                Vệt đỏ dưới đường như tranh Pollock (lên)
                Được vẽ bằng máu mấy thằng vô học (đúng rồi)
                Liên kết neuron về ổ chuột như sợi xích
                Tao nhớ thằng nhóc sợ hãi và cô độc
                Sợ bị ăn hiếp nên vô băng (gang)
                Đứng ở cây xăng nhưng mà không đổ xăng (vậy làm cái gì?)
                Đi với rắn nên tao không sợ rắn
                Nhưng bây giờ tao muốn làm thợ săn
                Tao không muốn làm công cụ, lãnh án giùm ông chủ
                Bị còng khi canh sòng, tao không phải là Long Tứ
                Bắt xác, rã đồ, bán lẻ, Phong Vũ
                Đem nồi ra sân nấu Tả Pí Lù, anh em mình phải đông đủ
                Sở thú tư nhân, ngã tư tử thần
                Không phải đột kích, Phú Nhuận
                Máu không đủ lạnh, tao không đú bẩn
                Tao không tự nhận, cũng không phủ nhận
                Mainstream, mấy cái đầu ngủ gật bị tao Slipknot
                Mấy thằng đó không có hip-hop (hip-hop), tụi nó giết chóc, ey
                Và tao bước ra từ cơn ác mộng đó, Hitchcock của TikTok, ey
                Gắn tai vô não mấy thằng nghe nhạc bằng mắt, làm nó điếc óc (điếc óc), ey
                Táo tụi nó còn nguyên, đến khi tao cắn một miếng, Steve Jobs, ey
                Tạt ngang club làm mày đổ mồ hôi, còn tiệc chính ở crib, nhóc, ey
                Nhắn fan mày đừng bỏ học vì tụi nó sẽ thành fan tao đó biết không (lil' bitch), ey
                Vô học chứ đừng vô ơn, rút ổ cắm coi chừng giựt điện, nhóc
                Kế hoạch vẫn như cũ, đơn giản tao phải thắng, không tư thù
                Unlimited cards, we forever big pocket
                Bước xuống phố, số lượng đông, M-O-B
                Không cần cố, không lòng vòng, thờ Phật Tổ
                Chắp tay trước ngực, cầu nguyện cho dân Châu Á
                Đứng ngang hàng, thậm chí là ngang tàng, wait
                Cúng nguyên con heo quay, mong con cái sau này không quậy (brrrra)
                Đóng tiền cho đi học trường quốc tế, xăm con rồng lên tay trái cho nó shock
                Móc cây pô nghe nhức óc
                Trái 62 xác con dream Thái
                Mở IC mở tour, vì cuộc đua này tụi tao cần tăng tốc
                Không còn đường nào ngoài đường thẳng, ey
                Gotta be success, that's my main mission
                I buy mama car (buy mama car), get her a mansion (get her a mansion)
                I'm livin' my life (I'm livin' my life), and dead every seconds
                Tao biết cổ phiếu sẽ tăng, nếu tao đồng ý sát nhập
                These rappers ain't rappin' no more
                I'm doing too well in case I'm a frog
                Everyday I'm prayin' the lord
                Hope I can make it through the dark
                Đến được thiên đàng như Wowy
                Chăm lo gia đình như anh Quý
                Nghĩ mình vĩ đại từ lúc nhỏ, còn nghĩ mình sẽ đi học cơ khí
                Đâu ngờ giờ làm rapper, thích hút cỏ, ey
                Đang canh em bé
                Đang canh em bé
                Đang canh em bé, hoh
                Coi chừng bị vấp
                Coi chừng bị té
                Coi chừng bị què, hoh
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
                I mean, on this with Low G
                On CD, DVD, mp3 and TV
                Got my side girl, she go retarded
                Lên thiên đàng, tao với Bình Vũ đang moshpit
                Book mẹ Vietjet xong tao hét ở Quận 3, Tăng Động và tao đây con chó (xời)
                Bắt quẻ thầy bói xong bói đúng như tử vi, năm nay tiền tao lên như gió (ay)
                Vua của Đống Đa, em ấy cau có, nghe giọng tao, lại u mê
                Tao phải chuyển em sang hướng Tây chếch khoảng hai centimet cho hợp phong thủy của nhà và tư thế
                Em ấy đòi bế trên thành ghế, tao cho té như vật tế, mấy thằng phế nhìn không nể lại ra khinh
                Bọn nó không biết tam giác giống tao (Giống như nào?), có ba đỉnh
                Đi ăn hủ tiếu gái bâu như đảo chính (ơ), mấy em da ngăm đùi căng như Latinh (ơ)
                Đang bận đái bậy cùng với cả Phan Anh, gái bâu vào xem hàng với thả thính (ơ)
                Mày gửi em ấy "bé hơn ba", nhưng tao vào làm người thứ ba (xời)
                Tao gửi em "bé hơn bằng ba", một tiếng sau mày bị đá (xời)
                Mua SH phải mua hạ giá (ay), cọc sổ đỏ, Rô, Cơ chùa Hà (OK)
                Last Fire Crew, Void Dreamers, Rap Nhà Làm, Nhà Hóa Học Đống Đa (yeah, yeah, yeah, yeah)
                Dáng đại gia và tao dạng ra đái
                Em say hi vì tao hài, có thai vì tao dài
                Tao ra Đống Đa iced out đá đông grill vàng để tao kiêu nàng
                Tao lên thiên đàng lấy biên bản cơ bản thư giãn cùng với Rap Nhà Làm
                AP, Low G, we gon' G-Low, H-Town, SG
                Stay up, get lit, fuck with us and gеt hit
                Mông đẹp như trăng rằm trung thu (ay-ay-ay-ay)
                Gái đầy nhà như là cù lũ (ay-ay-ay-ay)
                Nhuộm lông mu màu vàng trù phú (xời)
                Biến chim bạn thành Son Goku (xời)
                Hôm nay tao làm nhạc bốc phét (ay)
                Hôm sau làm nhạc deep đến đêm (ơ)
                Mười năm trước bố đi cứu net
                Mười năm sau tao cứu rap game (xời)
                """,
            ],
            imageUrls:
            [
                URL(string: "https://cdn.britannica.com/22/234622-050-4D6BD081/Australian-shepherd-dog-red-merle.jpg"),
                nil,
                URL(string: "https://as1.ftcdn.net/v2/jpg/04/98/65/04/1000_F_498650403_XfVkkiHQMhoG5DCxACGSvRX0qMSRfyOw.jpg"),
            ],
            tags:
            [
                "dogs",
            ])
    }
}

struct Comment: Codable, Identifiable {
    @DocumentID var id: String?
    var postedById: String
    var postedAt: Date

    var text: String
}
