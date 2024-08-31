//
//  Font+.swift
//  AppLuk
//
//  Created by Khang Nguyen on 8/30/24.
//

import Foundation
import SwiftUI

extension Font {
    static var com_regular: Font {
        Font.custom("Comfortaa", size: 18)
            .bold()
    }

    static var com_caption: Font {
        Font.custom("Comfortaa", size: 13)
    }

    static var com_title3: Font {
        Font.custom("Comfortaa", size: 20)
            .bold()
    }

    static var com_title2: Font {
        Font.custom("Comfortaa", size: 22)
            .bold()
    }

    static var com_regular_light: Font {
        Font.custom("Comfortaa", size: 18)
    }
}
