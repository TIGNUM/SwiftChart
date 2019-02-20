//
//  MyToBeVisionWorker.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 20/02/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit
import ReactiveKit

final class MyToBeVisionWorker {

    private let services: Services
    private let syncManager: SyncManager
    private let widgetDataManager: ExtensionsDataManager
    private let navigationItem: NavigationItem
    private let syncStateObserver: SyncStateObserver
    var toBeVisionDidChange: ((MyToBeVisionModel.Model?) -> Void)?

    init(services: Services, syncManager: SyncManager, navigationItem: NavigationItem) {
        self.navigationItem = navigationItem
        self.services = services
        self.syncManager = syncManager
        self.widgetDataManager = ExtensionsDataManager(services: services)
        syncStateObserver = SyncStateObserver(realm: services.mainRealm)
        syncStateObserver.onUpdate { [unowned self] _ in
            self.toBeVisionDidChange?(self.myToBeVision())
        }

        // Make sure that image directory is created.
        do {
            try FileManager.default.createDirectory(at: URL.imageDirectory, withIntermediateDirectories: true)
        } catch {
            log("failed to create image directory", level: .debug)
        }
    }

    var navItem: NavigationItem {
        return navigationItem
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

    func setMyToBeVisionReminder(_ remind: Bool) {
        services.userService.setMyToBeVisionReminder(remind)
    }

    func updateMyToBeVision(_ new: MyToBeVisionModel.Model) {
        services.userService.saveVisionAndSync(new, syncManager: syncManager, completion: nil)
        updateWidget()
    }

    func saveImage(_ image: UIImage) throws -> URL {
        return try image.save(withName: UUID().uuidString)
    }

    func isReady() -> Bool {
        return syncStateObserver.hasSynced(MyToBeVision.self)
    }

    func updateWidget() {
        widgetDataManager.update(.toBeVision)
    }
}
