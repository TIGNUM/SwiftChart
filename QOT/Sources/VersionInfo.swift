//
//  VersionInfo.swift
//  QOT
//
//  Created by Sam Wyndham on 14.09.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import Freddy

struct VersionInfo {

    let version: String
    let build: Int
    let updateURL: URL

    init(json: JSON) throws {
        let versionBuild: String = try json.getItemValue(at: .latestVersion)
        // This will give something like "0.9.4.1500" which we want to seperate into "0.9.4" & 1500
        let componants = versionBuild.components(separatedBy: ".")
        guard let buildString = componants.last, let build = Int(buildString) else {
            throw SimpleError(localizedDescription: "Init VersionInfo with json: \(json) failed. Invalid latestVersion")
        }

        self.version = componants.dropLast().joined(separator: ".")
        self.build = build
        self.updateURL = try json.getItemValue(at: .updateUrl)
    }

    static func parse(_ data: Data) throws -> VersionInfo {
        return try VersionInfo(json: try JSON(data: data))
    }
}
