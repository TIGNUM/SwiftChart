//
//  ScreenHelpDataWorker.swift
//  QOT
//
//  Created by Lee Arromba on 14/12/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

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
            let video = (helpItems.filter { $0.format == "video" }).first,
            let message = (helpItems.filter { $0.format == ContentItemTextStyle.paragraph.rawValue }).first,
            let headlineValue = headline.valueText,
            let imageURLStgring = video.valueImageURL,
            let imageURL = URL(string: imageURLStgring),
            let videoURLString = video.valueMediaURL,
            let videoURL = URL(string: videoURLString),
            let messageValue = message.valueText else {
                throw DataError.missingData
        }

        return ScreenHelp.Item(title: headlineValue,
                               imageURL: imageURL,
                               videoURL: videoURL,
                               message: messageValue)
    }
}
