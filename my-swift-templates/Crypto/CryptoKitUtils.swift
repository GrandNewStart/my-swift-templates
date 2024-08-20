//
//  CryptoKitUtils.swift
//  my-swift-templates
//
//  Created by Jinwoo Hwangbo on 8/20/24.
//
import Foundation
import CryptoKit

struct CryptoKitUtils {
    
    enum Algorithm {
        case AES_256_GCM
        case ChaCha20_Poly1305
    }
    
    static func generateKey(bytes: Int) -> Data {
        return SymmetricKey(size: .init(bitCount: bytes)).withUnsafeBytes { Data($0) }
    }
    
    static func generateKeyPair(_ algo: Algorithm) -> KeyPair {
        switch algo {
        case .AES_256_GCM:
            let privateKey = P256.KeyAgreement.PrivateKey()
            return KeyPair(
                privateKey: privateKey.rawRepresentation,
                publicKey: privateKey.publicKey.rawRepresentation
            )
        case .ChaCha20_Poly1305:
            let privateKey = P256.KeyAgreement.PrivateKey()
            return KeyPair(
                privateKey: privateKey.rawRepresentation,
                publicKey: privateKey.publicKey.rawRepresentation
            )
        }
    }
    
    static func generateSharedSecret(privateKey: Data, publicKey: Data) throws -> Data {
        let prv: P256.KeyAgreement.PrivateKey
        do {
            prv = try P256.KeyAgreement.PrivateKey(rawRepresentation: privateKey)
        } catch {
            throw NSError(domain: "CryptoKitUtils", code: 0)
        }
        
        let pub: P256.KeyAgreement.PublicKey
        do {
            pub = try P256.KeyAgreement.PublicKey(rawRepresentation: publicKey)
        } catch {
            throw NSError(domain: "CryptoKitUtils", code: 1)
        }
        
        do {
            return try prv.sharedSecretFromKeyAgreement(with: pub)
                .withUnsafeBytes { Data($0) }
        } catch {
            throw NSError(domain: "CryptoKitUtils", code: 2)
        }
    }
    
    static func encrypt(_ algo: Algorithm, data: Data, key: Data) throws -> Data {
        switch algo {
        case .AES_256_GCM:
            let box: AES.GCM.SealedBox
            do {
                box = try AES.GCM.seal(data, using: SymmetricKey(data: key))
            } catch {
                throw NSError(domain: "CryptoKitUtils", code: 3)
            }
            guard let result = box.combined else {
                throw NSError(domain: "CryptoKitUtils", code: 4)
            }
            return result
        case .ChaCha20_Poly1305:
            let box: ChaChaPoly.SealedBox
            do {
                box = try ChaChaPoly.seal(data, using: SymmetricKey(data: key))
            } catch {
                throw NSError(domain: "CryptoKitUtils", code: 5)
            }
            return box.combined
        }
    }
    
    static func decrypt(_ algo: Algorithm, data: Data, key: Data) throws -> Data {
        switch algo {
        case .AES_256_GCM:
            let box: AES.GCM.SealedBox
            do {
                box = try AES.GCM.SealedBox(combined: data)
            } catch {
                throw NSError(domain: "CryptoKitUtils", code: 6)
            }
            do {
                return try AES.GCM.open(box, using: SymmetricKey(data: key))
            } catch {
                throw NSError(domain: "CryptoKitUtils", code: 7)
            }
        case .ChaCha20_Poly1305:
            let box: ChaChaPoly.SealedBox
            do {
                box = try ChaChaPoly.SealedBox(combined: data)
            } catch {
                throw NSError(domain: "CryptoKitUtils", code: 8)
            }
            do {
                return try ChaChaPoly.open(box, using: SymmetricKey(data: key))
            } catch {
                throw NSError(domain: "CryptoKitUtils", code: 9)
            }
        }
    }
    
}
