//
//  GuideViewModel.swift
//  QOT
//
//  Created by karmic on 29.11.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import ReactiveKit
import RealmSwift
import UIKit

final class GuideViewModel {

    private let services: Services
    private let guideWorker: GuideWorker
    private let guideProvider: GuideProvider
    let updates = PublishSubject<CollectionUpdate, NoError>()
    let sectionCountUpdate = ReplayOneSubject<Int, NoError>()
    private var viewModel: Guide.Model?

    init(services: Services, eventTracker: EventTracker) {
        self.services = services
        self.guideWorker = GuideWorker(services: services)
        self.guideProvider = GuideProvider(services: services)

        guideProvider.onUpdate = { [unowned self] (viewModel) in
            self.viewModel = viewModel
            self.sectionCountUpdate.next(self.sectionCount)
            self.updates.next(.reload)
        }
    }

    func reload() {
        guideProvider.reload()
    }

    var message: String {
        return viewModel?.message ?? ""
    }

    func greeting() -> String {
        return viewModel?.greeting ?? ""
    }

    func todayCompleted() -> Bool {
        guard let today = days.first else {
            return true
        }
        let imcompleteLearn = today.items.filter {
            $0.status == .todo && RealmGuideItemLearn.ItemType(rawValue: $0.type) != nil
        }
        return imcompleteLearn.count == 0
    }

    var isReady: Bool {
        return guideWorker.hasSyncedNecessaryItems
    }

    var sectionCount: Int {
        return days.count
    }

    func numberOfRows(section: Int) -> Int {
        return days[section].items.count
    }

    func header(section: Int) -> Date {
        return days[section].localStartOfDay
    }

    func item(indexPath: IndexPath) -> Guide.Item {
        return days[indexPath.section].items[indexPath.row]
    }

    func setCompleted(item: Guide.Item, completion: @escaping () -> Void) {
        guard item.status == .todo else { return }
        cancelPendingNotificationIfNeeded(item: item)
        GuideWorker(services: services).setItemCompleted(guideID: item.identifier) { (error) in
            guard error == nil else { return }
            self.reload()
            completion()
        }
    }

    func cancelPendingNotificationIfNeeded(item: Guide.Item) {
        LocalNotificationBuilder.cancelNotification(identifier: item.identifier)
    }

    private var days: [Guide.Day] {
        return viewModel?.days ?? []
    }
}
