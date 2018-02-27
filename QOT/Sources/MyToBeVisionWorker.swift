//
//  MyToBeVisionWorker.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 20/02/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

final class MyToBeVisionWorker {

    private let services: Services

    init(services: Services) {
        self.services = services
    }

    func myToBeVision() -> MyToBeVisionModel.Model? {
        return services.userService.myToBeVision()?.model
    }

    func updateMyToBeVision(_ new: MyToBeVisionModel.Model) {
        guard let old = services.userService.myToBeVision(), old.model != new else { return }

        services.userService.updateMyToBeVision(old) {
            $0.headline = new.headLine
            $0.text = new.text
            $0.date = new.lastUpdated
            if let newImageURL = new.imageURL,
                let resource = $0.profileImageResource,
                resource.url != newImageURL,
                newImageURL.isFileURL {
                $0.profileImageResource?.setLocalURL(newImageURL,
                                                     format: .jpg,
                                                     entity: .toBeVision,
                                                     entitiyLocalID: $0.localID)
            }
        }
    }

    func saveImage(_ image: UIImage) throws -> URL {
        return try image.save(withName: UUID().uuidString)
    }

    var trackablePageObject: PageObject? {
        return services.userService.myToBeVision().map { PageObject(object: $0, identifier: .myToBeVision) }
    }
}

private extension MyToBeVision {

    var model: MyToBeVisionModel.Model {
        return MyToBeVisionModel.Model(headLine: headline,
                                       imageURL: profileImageResource?.url,
                                       lastUpdated: date,
                                       text: text)
    }
}
