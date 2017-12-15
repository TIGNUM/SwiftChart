//
//  ScreenHelpDataWorker.swift
//  QOT
//
//  Created by Lee Arromba on 14/12/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

class ScreenHelpDataWorker {
    enum DataError: Error {
        case badURL
        case missingKey
    }

    private let plistName: String

    init(plistName: String) {
        self.plistName = plistName
    }

    func getItem(for key: ScreenHelp.Plist.Key) throws -> ScreenHelp.Plist.Item {
        guard let plistURL = Bundle.main.url(forResource: plistName, withExtension: "plist") else {
            throw DataError.badURL
        }
        let plist = try readPlist(at: plistURL)
        guard let item = plist[key.rawValue] else {
            throw DataError.missingKey
        }
        return item
    }

    // MARK: - private

    private func readPlist(at url: URL) throws -> [String: ScreenHelp.Plist.Item] {
        let data = try Data(contentsOf: url)
        let decoder = PropertyListDecoder()
        return try decoder.decode([String: ScreenHelp.Plist.Item].self, from: data)
    }
}
