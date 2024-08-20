//
//  my_swift_templateTests.swift
//  my-swift-templateTests
//
//  Created by Jinwoo Hwangbo on 7/22/24.
//

import XCTest
@testable import my_swift_templates

final class EncodingTests: XCTestCase {

    func testBase64Utils() throws {
        let string = "Hello, World!"
        let bytes: [UInt8] = [72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33]
        let base64String = "SGVsbG8sIFdvcmxkIQ=="
        XCTAssertEqual(Base64Utils.encode(string: string), base64String)
        XCTAssertEqual(Base64Utils.encode(bytes: bytes), base64String)
        XCTAssertEqual(Base64Utils.decode(base64String: base64String), string)
    }
    
    func testHexUtils() throws {
        let string = "Hello, World!"
        let bytes: [UInt8] = [72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33]
        let hexString = "48656c6c6f2c20576f726c6421"
        XCTAssertEqual(HexUtils.bytesToHex(bytes: bytes), hexString)
        XCTAssertEqual(HexUtils.plainToHex(string: string), hexString)
        XCTAssertEqual(HexUtils.hexToBytes(hexString: hexString), bytes)
        XCTAssertEqual(HexUtils.hexToPlain(hexString: hexString), string)
    }

}
