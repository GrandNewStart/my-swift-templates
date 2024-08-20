//
//  CommonCryptoUtils.swift
//  my-swift-templates
//
//  Created by Jinwoo Hwangbo on 8/20/24.
//

import Foundation
import CommonCrypto

struct CommonCryptoUtils {
    
    static func md5(_ data: Data) -> Data {
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        data.withUnsafeBytes { byte in
            CC_MD5(byte.baseAddress, UInt32(data.count), &digest)
        }
        return Data(digest)
    }
    
}
