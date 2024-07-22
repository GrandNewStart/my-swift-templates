//
//  HexUtils.swift
//  my-swift-template
//
//  Created by Jinwoo Hwangbo on 7/22/24.
//

import Foundation

struct HexUtils {
    
    static func hexToBytes(hexString: String) -> [UInt8]? {
        var bytes = [UInt8]()
        var hexStr = hexString
        if hexStr.count % 2 != 0 {
            return nil // Hex string must have an even number of characters
        }
        while hexStr.count > 0 {
            let subIndex = hexStr.index(hexStr.startIndex, offsetBy: 2)
            let byteString = hexStr[..<subIndex]
            hexStr = String(hexStr[subIndex...])
            if let num = UInt8(byteString, radix: 16) {
                bytes.append(num)
            } else {
                return nil // Invalid hex character
            }
        }
        return bytes
    }
    
    static func hexToPlain(hexString: String) -> String? {
        if let bytes = hexToBytes(hexString: hexString) {
            let data = Data(bytes)
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
    
    static func bytesToHex(bytes: [UInt8]) -> String {
        return bytes.map { String(format: "%02x", $0) }.joined()
    }
    
    static func plainToHex(string: String) -> String? {
        if let bytes = string.data(using: .utf8) {
            return bytes.map { String(format: "%02x", $0) }.joined()
        }
        return nil
    }
    
}
