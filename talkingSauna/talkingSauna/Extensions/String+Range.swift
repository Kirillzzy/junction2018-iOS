//
//  String+Range.swift
//  VKAdmin
//
//  Created by Kirill Averyanov on 13/11/2017.
//  Copyright © 2017 Kirill Averyanov. All rights reserved.
//

import Foundation

extension String {
  func substring(from index: Int) -> String {
    return String(self[self.index(startIndex, offsetBy: index)...])
  }

  func substring(with range: Range<Int>) -> String {
    let startIndex = self.index(self.startIndex, offsetBy: range.lowerBound)
    let endIndex = self.index(self.startIndex, offsetBy: range.upperBound)
    return String(self[startIndex..<endIndex])
  }
  
  subscript(_ ind: Int) -> Character {
    return self[index(startIndex, offsetBy: ind)]
  }
  
  subscript(_ ind: Int) -> String {
    return String(self[ind] as Character)
  }
  
  subscript(_ rang: Range<Int>) -> String {
    let start = index(startIndex, offsetBy: rang.lowerBound)
    let end = index(startIndex, offsetBy: rang.upperBound)
    return String(self[start ..< end])
  }
}
