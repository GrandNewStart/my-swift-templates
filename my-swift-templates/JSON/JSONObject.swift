//
//  JSONObject.swift
//  my-swift-template
//
//  Created by Jinwoo Hwangbo on 7/22/24.
//

import Foundation

class JSONObject: Equatable {
    
    private var data: [String:Any] = [:]
    
    init() {}
    
    init(_ data: [String:Any]) {
        self.data = data
    }
    
    init(string: String) throws {
        if let data = string.data(using: .utf8),
           let json = try? JSONSerialization.jsonObject(with: data) as? [String:Any] {
            self.data = json
        } else {
            throw NSError(domain: "JSONObject", code: 0, userInfo: ["message":"invalid JSON string"])
        }
    }
    
    func put(key: String, value: Any) {
        if let value = value as? [JSONObject] {
            self.data[key] = value.map { $0.data }
        } else if let value = value as? JSONObject {
            self.data[key] = value.data
        } else {
            self.data[key] = value
        }
    }
    
    func get<T>(key: String) -> T? {
        return self.data[key] as? T
    }
    
    func getInt(key: String) -> Int? {
        return self.data[key] as? Int
    }
    
    func getDouble(key: String) -> Double? {
        return self.data[key] as? Double
    }
    
    func getBool(key: String) -> Bool? {
        return self.data[key] as? Bool
    }
    
    func getString(key: String) -> String? {
        return self.data[key] as? String
    }
    
    func getJSONObject(key: String) -> JSONObject? {
        if let data = self.data[key] as? [String:Any] {
            return JSONObject(data)
        }
        return nil
    }
    
    func getJSONArray(key: String) -> [JSONObject]? {
        if let array = self.data[key] as? [[String:Any]] {
            return array.map { return JSONObject($0) }
        }
        return nil
    }
    
    func remove(key: String) {
        self.data[key] = nil
    }
    
    func hasValue(for key: String) -> Bool {
        return self.data.contains(where: { k,_ in return k == key })
    }
    
    func toString() -> String {
        let data = try! JSONSerialization.data(withJSONObject: self.data)
        return String(data: data, encoding: .utf8)!
    }
    
    static func == (lhs: JSONObject, rhs: JSONObject) -> Bool {
        if lhs.data.count != rhs.data.count {
            return false
        }
        var result = true
        for key in lhs.data.keys {
            if lhs.get(key: key) != rhs.get(key: key) {
                result = false
                break
            }
        }
        return result
    }
    
}
