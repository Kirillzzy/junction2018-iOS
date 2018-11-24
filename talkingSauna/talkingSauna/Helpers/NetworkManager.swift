//
//  NetworkManager.swift
//  talkingSauna
//
//  Created by Kirill Averyanov on 11/24/18.
//  Copyright © 2018 Kirill Averyanov. All rights reserved.
//

import UIKit

final class NetworkManager {
  
  static let baseApi = "http://172.104.239.97:6969/"

  private static func managerService(with addString: String,
                                     httpMethod: String = "get",
                                     httpBody: Data? = nil,
                                     sessionTimeOut: TimeInterval = 1000,
                                     completion: @escaping (_ json: JSON?) -> Void) {
    
    guard let url = URL(string: addString) else { completion(nil); return }
    var sessionRequest = URLRequest(url: url)
    sessionRequest.httpMethod = httpMethod
    if let httpBody = httpBody {
      sessionRequest.httpBody = httpBody
    }
    
    let sessionConfig = URLSessionConfiguration.default
    sessionConfig.timeoutIntervalForRequest = sessionTimeOut
    sessionConfig.timeoutIntervalForResource = sessionTimeOut * 2
    
    let loadSession = URLSession(configuration: sessionConfig).dataTask(with: sessionRequest) { data, _, error in
      guard error == nil, let data = data else {
        completion(nil)
        return
      }
      print(String(data: data, encoding: .utf8))
      completion(JSON(data))
    }
    loadSession.resume()
  }
  
  static func sendRequest(with string: String, sessionTimeOut: TimeInterval = 1000,
                          completion: @escaping (_ json: JSON?) -> Void) {
    managerService(with: baseApi + string, sessionTimeOut: sessionTimeOut) { json in
      completion(json)
    }
  }
}
