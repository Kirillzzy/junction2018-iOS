//
//  LongPollSwiftService.swift
//  StreamQuiz
//
//  Created by Kirill Averyanov on 1/22/18.
//  Copyright © 2018 Kirill Averyanov. All rights reserved.
//

import Foundation

final class LongPollSwiftService {

  private var longPollUrlInitialString = ""
  private var isLongPollEnabled = true
  private let waitConstant = 30
  weak var delegate: LongPollSwiftServiceDelegate?
  
  init(longPollUrlInitialString: String, delegate: LongPollSwiftServiceDelegate?) {
    self.longPollUrlInitialString = longPollUrlInitialString
    self.delegate = delegate
    startLongPoll()
  }
  
  func removeBadSuffexes(_ json: JSON) -> JSON {
    let newString = String(describing: json).split(separator: "<")[0]
    return JSON(newString.data(using: .utf8) ?? Data())
  }
  
  private func sendLongPollRequest(urlString: String) {
    if !isLongPollEnabled { return }
    NetworkManager.sendRequest(with: urlString, completion: { [weak self] json in
      guard let json = json else {
        let newJson: JSON = [
          "type": "reload"
        ]
        NSLog("Error, json or self is nil, trying to reload, 35 line of LongPollSwiftService.swift")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: {
          if let strongSelf = self {
            self?.delegate?.longPollService(strongSelf, jsonEvents: newJson)
          }
        })
        return
      }
      if json["error"] != .null {
        let newJson: JSON = [
          "type": "reload"
        ]
        NSLog("Error, json error isn't .null, trying to reload, 45 line of LongPollSwiftService.swift")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: {
          if let strongSelf = self {
            self?.delegate?.longPollService(strongSelf, jsonEvents: newJson)
          }
        })
        return
      }
      if let strongSelf = self {
        self?.delegate?.longPollService(strongSelf, jsonEvents: json)
      }
      DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: {
        self?.createNewRequest(urlString: "last_message")
      })
    })
  }
  
  func stopLongPoll() {
    isLongPollEnabled = false
  }
  
  func startLongPoll() {
    isLongPollEnabled = true
    sendLongPollRequest(urlString: longPollUrlInitialString)
  }
  
  private func createNewRequest(urlString: String) {
    sendLongPollRequest(urlString: urlString)
  }
}
