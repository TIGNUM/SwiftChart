//
//  DatabaseKeyService.swift
//  QOT
//
//  Created by Lee Arromba on 15/08/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import KeychainAccess

class DatabaseKeyService {
    private let keychain = Keychain(service: KeychainConstant.service.rawValue)
    private let length = 64
    
    // print this and use in Realm Browser to open encrypted db
    var keyString: String? {
        guard let data = keyData else {
            return nil
        }
        // @see https://stackoverflow.com/questions/27011825/random-256bit-key-using-secrandomcopybytes-in-ios
        let string = NSMutableString()
        data.forEach({ (byte: UInt8) in
            string.appendFormat("%02x", byte)
        })
        return string as String
    }
    var keyData: Data? {
        return value(key: .databaseKey)
    }
    
    // @see https://developer.apple.com/documentation/security/1399291-secrandomcopybytes
    func generateNewKey() throws -> Data {
        var keyData = Data(count: length)
        let result = keyData.withUnsafeMutableBytes { (mutableBytes: UnsafeMutablePointer<UInt8>) -> Int32 in
            SecRandomCopyBytes(kSecRandomDefault, keyData.count, mutableBytes)
        }
        guard result == errSecSuccess else {
            throw SimpleError(localizedDescription: "SecRandomCopyBytes failed with code \(result)")
        }
        set(value: keyData, key: .databaseKey)
        return keyData
    }
    
    // MARK: - private
    
    private func value(key: KeychainConstant) -> Data? {
        guard let base64EncodedData = keychain[data: key.rawValue] else {
            return nil
        }
        return Data(base64Encoded: base64EncodedData)
    }
    
    private func set(value: Data?, key: KeychainConstant) {
        keychain[data: key.rawValue] = value?.base64EncodedData()
    }
}
