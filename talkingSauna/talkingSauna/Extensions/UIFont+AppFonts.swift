//
//  UIFont+AppFonts.swift
//  StreamQuiz
//
//  Created by Kirill Averyanov on 1/20/18.
//  Copyright © 2018 Kirill Averyanov. All rights reserved.
//

import UIKit.UIFont

extension UIFont {
  enum FontType {
    case systemFont(size: CGFloat)
    case systemMediumFont(size: CGFloat)
    case systemSemiboldFont(size: CGFloat)
    case systemBoldFont(size: CGFloat)
    case systemHeavyFont(size: CGFloat)
    case systemProFont(size: CGFloat)
    case systemProBoldFont(size: CGFloat)
    case systemProMediumFont(size: CGFloat)
    case systemProSemiboldFont(size: CGFloat)
    case systemProHeavyFont(size: CGFloat)
    case ttCommonsExtraBoldFont(size: CGFloat)
    case ttCommonsBoldFont(size: CGFloat)
    case ttCommonsDemiBoldFont(size: CGFloat)
  }
  
  static func appFont(_ fontType: FontType) -> UIFont {
    switch fontType {
    case let .systemFont(size):
      return UIFont.systemFont(ofSize: size)
    case let .systemMediumFont(size):
      return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.medium)
    case let .systemSemiboldFont(size):
      return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.semibold)
    case let .systemBoldFont(size):
      return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.bold)
    case let .systemHeavyFont(size):
      return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.heavy)
    case let .systemProFont(size):
      return UIFont(name: "SanFranciscoDisplay-Regular", size: size) ?? UIFont.systemFont(ofSize: size)
    case let .systemProBoldFont(size):
      return UIFont(name: "SanFranciscoDisplay-Bold", size: size) ?? UIFont.systemFont(ofSize: size)
    case let .systemProMediumFont(size):
      return UIFont(name: "SanFranciscoDisplay-Medium", size: size) ?? UIFont.systemFont(ofSize: size)
    case let .systemProSemiboldFont(size):
      return UIFont(name: "SanFranciscoDisplay-Semibold", size: size) ?? UIFont.systemFont(ofSize: size)
    case let .systemProHeavyFont(size):
      return UIFont(name: "SanFranciscoDisplay-Heavy", size: size) ?? UIFont.systemFont(ofSize: size)
    case let .ttCommonsExtraBoldFont(size):
      return UIFont(name: "TTCommons-Extrabold", size: size) ?? UIFont.systemFont(ofSize: size)
    case let .ttCommonsBoldFont(size):
      return UIFont(name: "TTCommons-Bold", size: size) ?? UIFont.systemFont(ofSize: size)
    case let .ttCommonsDemiBoldFont(size):
      return UIFont(name: "TTCommons-DemiBold", size: size) ?? UIFont.systemFont(ofSize: size)
    }
  }
}
