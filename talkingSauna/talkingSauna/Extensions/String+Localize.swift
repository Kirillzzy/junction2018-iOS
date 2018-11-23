//
//  String+Localize.swift
//  VKAdmin
//
//  Created by Kirill Averyanov on 13/11/2017.
//  Copyright © 2017 Kirill Averyanov. All rights reserved.
//

import Foundation

extension String {
  
  var localized: String {
    return NSLocalizedString(self, comment: "")
  }
  
  func formatLocalized(with arg: CVarArg) -> String {
    return String.localizedStringWithFormat(localized, arg)
  }
  
}
