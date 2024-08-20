//
//  SecurityUtilsTests.swift
//  my-swift-templatesTests
//
//  Created by Jinwoo Hwangbo on 8/20/24.
//

import XCTest
@testable import my_swift_templates

class SecurityUtilsTests: XCTestCase {
    
    func testECDH() throws {
        let kp1 = try SecurityUtils.generateECKeyPair()
        let kp2 = try SecurityUtils.generateECKeyPair()
        
        let sec1 = try SecurityUtils.generateECDHSharedSecret(
            privateKey: try kp1.privateKey.toPrivateKey(),
            publicKey: try kp2.publicKey.toPublicKey()
        )
        let sec2 = try SecurityUtils.generateECDHSharedSecret(
            privateKey: try kp2.privateKey.toPrivateKey(),
            publicKey: try kp1.publicKey.toPublicKey()
        )
        
        XCTAssertEqual(sec1, sec2)
    }
    
    func testKeychain() throws {
        let kp = try SecurityUtils.generateECKeyPair()
        print(kp.description)
        
        try SecurityUtils.storeKeyPair(kp)
        
        let kpp = try SecurityUtils.getKeyPair()
        XCTAssertEqual(kp.description, kpp.description)
        
        try SecurityUtils.removeKeyPair()
        
        XCTAssertThrowsError(try SecurityUtils.getKeyPair())
    }
    
}
