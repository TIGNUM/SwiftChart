//
//  ContentItem+Convenience.swift
//  QOT
//
//  Created by Sam Wyndham on 24.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

extension ContentItem {

    var contentItemValue: ContentItemValue {
        return ContentItemValue(item: self)
    }

    var contentItemTextStyle: ContentItemTextStyle {
        guard
            let contentItemFormat = ContentItemFormat(rawValue: format),
            let contentItemTextStyle = ContentItemTextStyle.createStyle(for: contentItemFormat) else {
                fatalError("ContentItemFormat is not valid or nil.")
        }

        return contentItemTextStyle
    }

    var bundledAudioURL: URL? {
        guard let mediaID = valueMediaID.value, let fileName = bundledMediaNames[mediaID] else {
            return nil
        }
        return Bundle.main.url(forResource: fileName, withExtension: nil)
    }
}

// MARK: Helpers

private struct BundledMediaResource: Codable {
    
    let mediaID: Int
    let fileName: String
}

private var bundledMediaNames: [Int: String] = {
    let fileURL = Bundle.main.url(forResource: "bundled_media", withExtension: "plist")!
    do {
        let data = try Data(contentsOf: fileURL)
        let decoder = PropertyListDecoder()
        var names: [Int: String] = [:]
        for resource in try decoder.decode([BundledMediaResource].self, from: data) {
            names[resource.mediaID] = resource.fileName
        }
        return names
    } catch {
        fatalError("cannot decode bundled media plist: \(error)")
    }
}()
