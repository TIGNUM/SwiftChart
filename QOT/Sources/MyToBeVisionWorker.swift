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
    private let syncManager: SyncManager
    private let widgetDataManager: WidgetDataManager

    init(services: Services, syncManager: SyncManager) {
        self.services = services
        self.syncManager = syncManager
        self.widgetDataManager = WidgetDataManager(services: services)

        // Make sure that image directory is created.
        do {
            try FileManager.default.createDirectory(at: URL.imageDirectory, withIntermediateDirectories: true)
        } catch {
            log("failed to create image directory", level: .debug)
        }
    }

    var trackablePageObject: PageObject? {
        return services.userService.myToBeVision().map { PageObject(object: $0, identifier: .myToBeVision) }
    }

    var visionChatItems: [VisionGeneratorChoice.QuestionType: [ChatItem<VisionGeneratorChoice>]] {
        return services.questionsService.visionChatItems
    }

    var headlinePlaceholder: String? {
        return services.contentService.toBeVisionHeadlinePlaceholder()?.uppercased()
    }

    var messagePlaceholder: String? {
        return services.contentService.toBeVisionMessagePlaceholder()
    }

    func myToBeVision() -> MyToBeVisionModel.Model? {
        return services.userService.myToBeVision()?.model
    }

    func updateMyToBeVision(_ new: MyToBeVisionModel.Model) {
        services.userService.saveVisionAndSync(new, syncManager: syncManager, completion: nil)
        widgetDataManager.update(.toBeVision)
    }

    func saveImage(_ image: UIImage) throws -> URL {
        return try image.save(withName: UUID().uuidString)
    }
}
