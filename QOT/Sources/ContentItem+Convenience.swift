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
        guard let remoteID = remoteID.value else {
            return nil
        }
        // FIXME: This is bad because we are assuming that the bundled media will only be used by a single content item.
        // We should really have a new model type and API endpoints specifically for media.
        return Bundle.main.url(forResource: "\(remoteID)", withExtension: "m4a")
    }
}
