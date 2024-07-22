//
//  Base64Utils.swift
//  my-swift-template
//
//  Created by Jinwoo Hwangbo on 7/22/24.
//

import Foundation

struct Base64Utils {
    
    static func encode(bytes: [UInt8]) -> String {
      let data = Data(bytes)
      return data.base64EncodedString()
    }
      
    static func encode(string: String) -> String {
      if let data = string.data(using: .utf8) {
          return data.base64EncodedString()
      }
      return ""
    }

    static func decode(base64String: String) -> String {
      if let data = Data(base64Encoded: base64String), let decodedString = String(data: data, encoding: .utf8) {
          return decodedString
      }
      return ""
    }
    
}
