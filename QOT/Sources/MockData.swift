//
//  MockData.swift
//  QOT
//
//  Created by Sam Wyndham on 10/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift
import LoremIpsum
import Alamofire

// FIXME: Remove when no longer needed

private let syncManager: SyncManager = {
    let requestBuilder = URLRequestBuilder(baseURL: URL(string: "http://example.com")!, deviceID: deviceID)
    let networkManager = MockNetworkManager(sessionManager: SessionManager.default, credentialsManager: CredentialsManager(), requestBuilder: requestBuilder)
    let realmProvider = RealmProvider()
    let syncRecordService = SyncRecordService(realmProvider: realmProvider)
    return SyncManager(networkManager: networkManager, syncRecordService: syncRecordService, realmProvider: realmProvider)
}()

var textItemJSON: String {
    var dict: [String: Any] = [:]
    dict["text"] = LoremIpsum.sentences(withNumber: Int.random(between: 5, and: 15))

    return jsonDictToString(dict: dict)
}

func jsonDictToString(dict: [String: Any]) -> String {
    if
        let data = try? JSONSerialization.data(withJSONObject: dict, options: []),
        let string = String(data: data, encoding: .utf8) {
            return string
    } else {
        fatalError("Could not create textItemJSON!")
    }
}

// MARK: - Extensions

extension Int {
    /// Returns random number from `min` to `max` exclusive.
    static func random(between min: Int, and max: Int) -> Int {
        assert(min < max)
        return Int(arc4random_uniform(UInt32(max) - UInt32(min))) + min
    }

    static var randomID: Int {
        return Int.random(between: 100000000, and: 999999999)
    }
}

private extension Array {
    func randomItem() -> Element {
        return self[Int(arc4random_uniform(UInt32(self.count)))]
    }
}
