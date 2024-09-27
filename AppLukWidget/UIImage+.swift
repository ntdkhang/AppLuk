//
//  UIImage+.swift
//  AppLukWidgetExtension
//
//  Created by Khang Nguyen on 9/26/24.
//

import Foundation
import SwiftUI

extension UIImage {
    func resized(toWidth width: CGFloat = 800) -> UIImage {
      if size.width > 800 {
          let canvas = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
          let format = imageRendererFormat
          format.opaque = false
          return UIGraphicsImageRenderer(size: canvas, format: format).image {
              _ in draw(in: CGRect(origin: .zero, size: canvas))
          }
      }
      else {
          return self
      }
  }
}
