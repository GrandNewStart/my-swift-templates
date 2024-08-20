//
//  KeyPair.swift
//  my-swift-templates
//
//  Created by Jinwoo Hwangbo on 8/19/24.
//

import Foundation

struct KeyPair {
    let privateKey: Data
    let publicKey: Data
    
    var description: String {
        return """
        {
            "privateKey": "\(HexUtils.bytesToHex(bytes: privateKey.map{ $0 }))",
            "publicKey": "\(HexUtils.bytesToHex(bytes: publicKey.map{ $0 }))"
        }
        """
    }
}
