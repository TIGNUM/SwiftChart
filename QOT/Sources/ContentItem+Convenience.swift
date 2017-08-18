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
}
