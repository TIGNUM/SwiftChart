//
//  ScreenHelpDataWorker.swift
//  QOT
//
//  Created by Lee Arromba on 14/12/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

final class ScreenHelpDataWorker {

    enum DataError: Error {
        case badURL
        case missingData
    }

    let services: Services

    init(services: Services) {
        self.services = services
    }

    func getItem(for section: ScreenHelp.Category) throws -> ScreenHelp.Item? {
        guard let helpContent = services.contentService.contentCollection(id: section.rawValue) else {
            throw DataError.missingData
        }

        let helpItems = helpContent.items.sorted(by: [.sortOrder()])
        guard
            let headline = (helpItems.filter { $0.format == ContentItemTextStyle.h3.rawValue }).first,
            let message = (helpItems.filter { $0.format == ContentItemTextStyle.paragraph.rawValue }).first,
            let headlineValue = headline.valueText,
            let messageValue = message.valueText else {
                throw DataError.missingData
        }
        return ScreenHelp.Item(title: headlineValue,
                               imageURL: imageURL(helpItems),
                               videoURL: videoURL(helpItems),
                               message: messageValue)
    }

    func contentItemVideo(for mediaURL: URL?) -> ContentItem? {
        return services.contentService.contentItemsVideo().filter { $0.valueMediaURL ?? "" == mediaURL?.absoluteString ?? "" }.first
    }
}

private extension ScreenHelpDataWorker {

    func imageURL(_ helpItems: Results<ContentItem>) -> URL? {
        guard let imageURLStgring = mediaItem(helpItems)?.valueImageURL else { return nil }
        return URL(string: imageURLStgring)
    }

    func videoURL(_ helpItems: Results<ContentItem>) -> URL? {
        guard let videoURLString = mediaItem(helpItems)?.valueMediaURL else { return nil }
        return URL(string: videoURLString)
    }

    func mediaItem(_ helpItems: Results<ContentItem>) -> ContentItem? {
        return (helpItems.filter { $0.format == "video" }).first
    }
}
