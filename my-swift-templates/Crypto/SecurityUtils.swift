//
//  SecurityUtils.swift
//  my-swift-templates
//
//  Created by Jinwoo Hwangbo on 8/19/24.
//

import Foundation
import Security

extension SecKey {
    
    func toData() throws -> Data {
        var error: Unmanaged<CFError>?
        guard let data = SecKeyCopyExternalRepresentation(self, &error) else {
            throw NSError(domain: "SecKey+", code: 0)
        }
        return data as Data
    }
    
}


extension Data {
    
    func toPrivateKey() throws -> SecKey {
        var error: Unmanaged<CFError>?
        guard let key = SecKeyCreateWithData(
            self as CFData,
            [
                kSecAttrKeyClass: kSecAttrKeyClassPrivate,
                kSecAttrKeyType: kSecAttrKeyTypeEC,
            ] as CFDictionary,
            &error
        ) else {
            print(error!.takeRetainedValue())
            throw NSError(domain: "Data+", code: 0)
        }
        return key
    }
    
    func toPublicKey() throws -> SecKey {
        var error: Unmanaged<CFError>?
        guard let key = SecKeyCreateWithData(
            self as CFData,
            [
                kSecAttrKeyClass: kSecAttrKeyClassPublic,
                kSecAttrKeyType: kSecAttrKeyTypeEC
            ] as CFDictionary,
            &error
        ) else {
            print(error!.takeRetainedValue())
            throw NSError(domain: "Data+", code: 0)
        }
        return key
    }
    
}

struct SecurityUtils {
    
    static let TAG = "dev.jinwoo.myswifttemplates"
    
    static func generateECKeyPair() throws -> KeyPair {
        var error: Unmanaged<CFError>?
        guard let key = SecKeyCreateRandomKey([
            kSecClass: kSecClassKey,
            kSecAttrKeyType: kSecAttrKeyTypeEC,
            kSecAttrApplicationTag: TAG,
            kSecAttrKeySizeInBits: 256,
        ] as CFDictionary, &error) else {
            throw NSError(domain: "SecurityUtils", code: 0, userInfo: ["message":"key generation failed"])
        }
        guard let publicKey = SecKeyCopyPublicKey(key) else {
            throw NSError(domain: "SecurityUtils", code: 1, userInfo: ["message":"public key extraction failed"])
        }
        return KeyPair(
            privateKey: try key.toData(),
            publicKey: try publicKey.toData()
        )
    }
    
    static func generateECDHSharedSecret(privateKey: SecKey, publicKey: SecKey) throws -> Data {
        var error: Unmanaged<CFError>?
        guard let secret = SecKeyCopyKeyExchangeResult(
            privateKey, 
            .ecdhKeyExchangeStandard,
            publicKey,
            [:] as CFDictionary,
            &error
        ) else {
            throw NSError(domain: "SecurityUtils", code: 2, userInfo: ["message":"shared secret generation failed"])
        }
        return secret as Data
    }
    
    static func storeKeyPair(_ kp: KeyPair) throws {
        let key = try kp.privateKey.toPrivateKey()
        let status = SecItemAdd(
            [
                kSecClass: kSecClassKey,
                kSecAttrApplicationTag: TAG,
                kSecValueRef: key
            ] as CFDictionary,
            nil
        )
        if status != errSecSuccess {
            throw NSError(domain: "SecurityUtils", code: 3)
        }
    }
    
    static func getKeyPair() throws -> KeyPair {
        var item: CFTypeRef?
        SecItemCopyMatching(
            [
                kSecClass: kSecClassKey,
                kSecAttrApplicationTag: TAG,
                kSecReturnRef: true
            ] as CFDictionary,
            &item
        )
        guard let item = item else {
            throw NSError(domain: "SecurityUtils", code: 4)
        }
        print(item)
        guard let publicKey = SecKeyCopyPublicKey(item as! SecKey) else {
            throw NSError(domain: "SecurityUtils", code: 5)
        }
        return KeyPair(
            privateKey: try (item as! SecKey).toData(),
            publicKey: try publicKey.toData()
        )
    }
    
    static func removeKeyPair() throws {
        let status = SecItemDelete([
            kSecClass: kSecClassKey,
            kSecAttrApplicationTag: TAG,
            kSecAttrKeyType: kSecAttrKeyTypeEC,
        ] as CFDictionary)
        print(getMessage(status))
        if status != errSecSuccess {
            throw NSError(domain: "SecurityUtils", code: 6)
        }
    }
    
    static func getMessage(_ status: OSStatus) -> String {
        guard let message = SecCopyErrorMessageString(status, nil) else {
            return ""
        }
        return message as String
    }
    
}
