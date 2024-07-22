//
//  my_swift_templateTests.swift
//  my-swift-templateTests
//
//  Created by Jinwoo Hwangbo on 7/22/24.
//

import XCTest
@testable import my_swift_template

final class MySwiftTemplateTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

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
    
    func testJSONObject() throws {
        let jsonString = """
            {"a":0, "b": "B", "c": true, "d": 1.1, "e": {"f": 1, "g": "G", "h": false, "i": 1.2}}
        """
        let jsonData:[String:Any] = [
            "a": 0,
            "b": "B",
            "c": true,
            "d": 1.1,
            "e": [
                "f": 1,
                "g": "G",
                "h": false,
                "i": 1.2
            ]
        ]
        let jsonObject1 = JSONObject(jsonData)
        let jsonObject2 = try JSONObject(string: jsonString)
        let jsonArray = [
            JSONObject(["k1":"v1", "k2": 2, "k3": false, "k4": 0.4, "k5": ["r1":"v1", "r2":3, "r3":true, "r4":0.5]]),
            JSONObject(["i1":"v1", "i2": 2, "i3": false, "i4": 0.4, "i5": ["t1":"v1", "t2":3, "t3":true, "t4":0.5]]),
            JSONObject(["j1":"j1", "k2": 2, "j3": false, "j4": 0.4, "j5": ["w1":"v1", "w2":3, "w3":true, "w4":0.5]]),
            JSONObject(["u1":"u1", "u2": 2, "u3": false, "u4": 0.4, "u5": ["e1":"v1", "e2":3, "e3":true, "e4":0.5]])
        ]
        jsonObject1.put(key: "z", value: jsonArray)
        jsonObject2.put(key: "z", value: jsonArray)
        XCTAssertEqual(jsonObject1.getInt(key: "a"), jsonObject2.getInt(key: "a"))
        XCTAssertEqual(jsonObject1.getString(key: "b"), jsonObject2.getString(key: "b"))
        XCTAssertEqual(jsonObject1.getBool(key: "c"), jsonObject2.getBool(key: "c"))
        XCTAssertEqual(jsonObject1.getDouble(key: "d"), jsonObject2.getDouble(key: "d"))
        XCTAssertEqual(jsonObject1.getJSONObject(key: "e"), jsonObject2.getJSONObject(key: "e"))
        XCTAssertEqual(jsonObject1.getJSONArray(key: "z"), jsonObject2.getJSONArray(key: "z"))
        XCTAssertEqual(jsonObject1, jsonObject2)
        print(jsonObject1.toString())
        print(jsonObject2.toString())
    }

}
