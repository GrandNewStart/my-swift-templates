//
//  CryptoKitUtilsTests.swift
//  my-swift-templates
//
//  Created by Jinwoo Hwangbo on 8/20/24.
//

import XCTest
@testable import my_swift_templates

class CryptoKitUtilsTests: XCTestCase {
    
    func testEncryption() throws {
        let msg = "Hello, World!"
        let data = msg.data(using: .utf8)!
        
        let kp1 = CryptoKitUtils.generateKeyPair(.AES_256_GCM)
        let kp2 = CryptoKitUtils.generateKeyPair(.AES_256_GCM)
        
        let sec1 = try CryptoKitUtils.generateSharedSecret(
            privateKey: kp1.privateKey,
            publicKey: kp2.publicKey
        )
        let sec2 = try CryptoKitUtils.generateSharedSecret(
            privateKey: kp1.privateKey,
            publicKey: kp2.publicKey
        )
        XCTAssertEqual(sec1, sec2)
        
        let enc1 = try CryptoKitUtils.encrypt(.AES_256_GCM, data: data, key: sec1)
        let dec1 = try CryptoKitUtils.decrypt(.AES_256_GCM, data: enc1, key: sec2)
        let enc2 = try CryptoKitUtils.encrypt(.ChaCha20_Poly1305, data: data, key: sec2)
        let dec2 = try CryptoKitUtils.decrypt(.ChaCha20_Poly1305, data: enc2, key: sec1)
        XCTAssertEqual(dec1, data)
        XCTAssertEqual(dec2, data)
    }
    
}
