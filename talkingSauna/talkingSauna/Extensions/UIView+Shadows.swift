//
//  UIView+Shadows.swift
//  fiveWords
//
//  Created by Kirill Averyanov on 11/6/18.
//  Copyright © 2018 Kirill Averyanov. All rights reserved.
//

import UIKit
import QuartzCore

extension CALayer {
  
  func addShadow(color: UIColor, alpha: Float = 1.0,
                 x: CGFloat, y: CGFloat,
                 blur: CGFloat = 0, spread: CGFloat = 0) {
    shadowColor = color.cgColor
    shadowOpacity = alpha
    shadowOffset = CGSize(width: x, height: y)
    shadowRadius = blur / 2.0
    
    if spread == 0 {
      shadowPath = nil
    } else {
      let dx = -spread
      let rect = bounds.insetBy(dx: dx, dy: dx)
      
      shadowPath = UIBezierPath(rect: rect).cgPath
    }
  }
  
}

extension UIView {
  func withShadow(color: UIColor, radius: CGFloat = 15) {
    layer.shadowColor = color.cgColor
    layer.shadowOpacity = 1
    layer.shadowOffset = .zero
    layer.shadowRadius = radius
  }
}
