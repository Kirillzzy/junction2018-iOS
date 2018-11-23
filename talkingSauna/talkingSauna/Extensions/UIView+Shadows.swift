//
//  UIView+Shadows.swift
//  fiveWords
//
//  Created by Kirill Averyanov on 11/6/18.
//  Copyright © 2018 Kirill Averyanov. All rights reserved.
//

import UIKit

extension UIView {
  func withShadow(color: UIColor, radius: CGFloat = 10) {
    layer.shadowColor = color.cgColor
    layer.shadowOpacity = 0.15
    layer.shadowOffset = .zero
    layer.shadowRadius = radius
  }
}
