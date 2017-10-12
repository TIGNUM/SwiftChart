//
//  LogInfo.swift
//  QOT
//
//  Created by Lee Arromba on 12/10/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

struct LogInfo: Codable {
    let userId: Int?
    let deviceId: String?
    let deviceModel: String
    let iosVersion: String
    let qotVersion: String
    let connectivity: String
    let timestamp: String
    let logLevel: Int
    let thread: String
    let file: String
    let message: String
    let function: String
    let line: Int
}

extension LogInfo {
    var json: [String : Any]? {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(self)
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    var jsonString: String? {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(self)
            return String(data: data, encoding: .utf8)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
