//
//  LongPollSwiftServiceDelegate.swift
//  StreamQuiz
//
//  Created by Kirill Averyanov on 1/22/18.
//  Copyright © 2018 Kirill Averyanov. All rights reserved.
//

import Foundation

protocol LongPollSwiftServiceDelegate: class {
  func longPollService(_ service: LongPollSwiftService, jsonEvents: JSON)
}
